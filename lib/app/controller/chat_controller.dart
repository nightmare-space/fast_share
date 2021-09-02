import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/pages/item/message_item_factory.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:speed_share/pages/model/model_factory.dart';
import 'package:speed_share/utils/shelf/static_handler.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:file_manager_view/file_manager_view.dart' as fm;
import 'package:speed_share/utils/string_extension.dart';

class ChatController extends GetxController {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  GetSocket socket;
  List<Widget> children = [];
  List<String> addreses = [];
  ScrollController scrollController = ScrollController();
  bool isConnect = false;
  String chatRoomUrl = '';

  @override
  void onClose() {
    if (isConnect) {
      socket.close();
    }
    Log.e('dispose');
    Global().enableShowDialog();
    Global().stopSendBoradcast();
    focusNode.dispose();
    controller.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void serverFile(String path) {
    Log.e('部署 path -> $path');
    String filePath = path.replaceAll('\\', '/');
    filePath = filePath.replaceAll(RegExp('^[A-Z]:'), '');
    filePath = filePath.replaceAll(RegExp('^/'), '');
    // 部署文件
    String url = p.toUri(filePath).toString();
    Log.e('部署 url -> $url');
    var handler = createFileHandler(path, url: url);
    io.serve(
      handler,
      InternetAddress.anyIPv4,
      Config.shelfPort,
      shared: true,
    );
  }

  Future<void> sendDir() async {
    String dirPath;
    if (GetPlatform.isDesktop) {
      dirPath = await FileSelectorPlatform.instance.getDirectoryPath(
        confirmButtonText: '选择',
      );
    } else {
      dirPath = await fm.FileManager.pickDirectory(Get.context);
    }
    Log.d('dirPath -> $dirPath');
    if (dirPath == null) {
      return;
    }
    Directory dir = Directory(dirPath);

    String fileUrl = '';
    List<String> address = await PlatformUtil.localAddress();
    for (String addr in address) {
      fileUrl += 'http://' + addr + ':${Config.shelfPort} ';
    }
    fileUrl = fileUrl.trim();
    // 可能会存在两个不同路径下有相同文件夹名的问题
    String dirName = p.basename(dirPath);
    MessageBaseInfo info = MessageInfoFactory.fromJson({
      'dirName': dirName,
      'msgType': 'dir',
      'urlPrifix': fileUrl,
      'fullSize': 0,
    });

    // 发送消息
    socket.send(info.toString());
    // 将消息添加到本地列表
    children.add(MessageItemFactory.getMessageItem(
      info,
      true,
    ));
    scroll();
    update();
    List<FileSystemEntity> list = await dir.list(recursive: true).toList();
    list.forEach((element) async {
      FileSystemEntity entity = element;
      String suffix = '';
      int size = 0;
      if (entity is Directory) {
        suffix = '/';
      } else if (entity is File) {
        size = await entity.length();

        serverFile(entity.path);
      }
      dynamic info = MessageInfoFactory.fromJson({
        'path': element.path + suffix,
        'size': size,
        'msgType': 'dirPart',
        'partOf': dirName,
      });
      socket.send(info.toString());
    });
    info = MessageInfoFactory.fromJson({
      'stat': 'complete',
      // 'size':element.s
      'msgType': 'dirPart',
      'partOf': dirName,
    });

    // TODO 这行是测试代码
    await Future.delayed(Duration(seconds: 1));
    socket.send(info.toString());
  }

  Future<void> sendFileForDesktop() async {
    final typeGroup = XTypeGroup(
      label: 'images',
    );
    final files = await FileSelectorPlatform.instance
        .openFiles(acceptedTypeGroups: [typeGroup]);
    if (files.isEmpty) {
      return;
    }
    for (XFile xFile in files) {
      final file = xFile;
      serverFile(file.path);
      // 替换windows的路径分隔符
      String filePath = file.path.replaceAll('\\', '/');
      int size = await File(filePath).length();

      filePath = filePath.replaceAll(RegExp('^[A-Z]:'), '');
      String url = '';
      List<String> address = await PlatformUtil.localAddress();
      for (String addr in address) {
        url += 'http://' + addr + ':${Config.shelfPort} ';
      }
      url = url.trim();
      p.Context context;
      if (GetPlatform.isWindows) {
        context = p.windows;
      } else {
        context = p.posix;
      }
      MessageBaseInfo info = MessageInfoFactory.fromJson({
        'filePath': filePath,
        'msgType': 'file',
        'fileName': context.basename(filePath),
        'fileSize': FileSizeUtils.getFileSize(size),
        'url': url,
      });
      // Log.w(await PlatformUtil.localAddress());
      // 发送消息
      socket.send(info.toString());
      // 将消息添加到本地列表
      children.add(MessageItemFactory.getMessageItem(
        info,
        true,
      ));
      scroll();
      update();
    }
  }

  Future<void> sendFileForAndroid({bool useSystemPicker = false}) async {
    // 选择文件路径
    List<String> filePaths = [];
    if (!useSystemPicker) {
      List<fm.FileEntity> pickResult = await fm.FileManager.pickFiles(
        Get.context,
      );
      pickResult.forEach((element) {
        filePaths.add(element.path);
      });
    } else {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowCompression: false,
        allowMultiple: true,
      );
      if (result != null) {
        for (PlatformFile file in result.files) {
          filePaths.add(file.path);
        }
        // PlatformFile file = result.files.first;

        // print(file.name);
        // print(file.bytes);
        // print(file.size);
        // print(file.extension);
        // print(file.path);
        // filePath = file.path;
      } else {
        // User canceled the picker
      }
    }
    for (String filePath in filePaths) {
      print(filePath);
      if (filePath == null) {
        return;
      }
      sendFileFromPath(filePath);
    }
  }

  Future<void> sendFileFromPath(String filePath) async {
    serverFile(filePath);
    int size = await File(filePath).length();
    String fileUrl = '';
    List<String> address = await PlatformUtil.localAddress();
    for (String addr in address) {
      fileUrl += 'http://' + addr + ':${Config.shelfPort} ';
    }
    fileUrl = fileUrl.trim();
    dynamic info = MessageInfoFactory.fromJson({
      'filePath': filePath,
      'msgType': 'file',
      'thumbnailPath': '',
      'fileName': p.basename(filePath),
      'fileSize': FileSizeUtils.getFileSize(size),
      'url': fileUrl,
    });
    // 发送消息
    socket.send(info.toString());
    // 将消息添加到本地列表
    children.add(MessageItemFactory.getMessageItem(
      info,
      true,
    ));
    scroll();
    update();
  }

  Future<void> sendAddressAndQrCode() async {
    // 这个if的内容是创建房间的设备，会得到本机ip的消息
    children.add(MessageItemFactory.getMessageItem(
      MessageTextInfo(
        content: '当前窗口可通过以下url加入，也可以使用浏览器直接打开以下url，'
            '只有同局域网下的设备能打开喔~',
      ),
      false,
    ));
    List<String> addreses = await PlatformUtil.localAddress();
    // 10开头一般是数据网络的IP，后续考虑通过设置放开
    // addreses.removeWhere((element) => element.startsWith('10.'));
    if (addreses.isEmpty) {
      children.add(MessageItemFactory.getMessageItem(
        MessageTextInfo(content: '未发现局域网IP'),
        false,
      ));
    } else {
      for (String address in addreses) {
        // 添加一行文本消息
        children.add(MessageItemFactory.getMessageItem(
          MessageTextInfo(content: 'http://$address:${Config.chatPort}'),
          false,
        ));
        // 添加一行二维码消息
        children.add(MessageItemFactory.getMessageItem(
          MessageQrInfo(content: 'http://$address:${Config.chatPort}'),
          false,
        ));
      }
    }
    update();
    scroll();
  }

  Map<String, int> dirItemMap = {};
  Map<String, MessageDirInfo> dirMsgMap = {};
  void listenMessage() {
    Log.e('监听');
    socket.onMessage((message) {
      if (message == '') {
        // 发来的空字符串就没必要解析了
        return;
      }
      Map<String, dynamic> map;
      try {
        map = jsonDecode(message);
      } catch (e) {
        return;
      }
      MessageBaseInfo messageInfo = MessageInfoFactory.fromJson(map);
      if (messageInfo is MessageDirInfo) {
        // 保存文件夹消息所在的index
        dirItemMap[messageInfo.dirName] = children.length;
        dirMsgMap[messageInfo.dirName] = messageInfo;
        if (!GetPlatform.isWeb) {
          for (String url in messageInfo.urlPrifix.split(' ')) {
            Uri uri = Uri.parse(url);
            Log.v('消息带有的address -> ${uri.host}');
            for (String localAddr in addreses) {
              if (uri.host.hasThreePartEqual(localAddr)) {
                Log.d('其中消息的 -> ${uri.host} 与本地的$localAddr 在同一个局域网');
                messageInfo.urlPrifix = url;
              }
            }
          }
          if (messageInfo.urlPrifix.contains(' ')) {
            // 这儿是没有找到同一个局域网，有可能划分了子网
            messageInfo.urlPrifix = messageInfo.urlPrifix.split(' ').first;
          }
        } else {
          messageInfo.urlPrifix = messageInfo.urlPrifix.split(' ').first;
        }
        Log.w('dirItemMap -> $dirItemMap');
      } else if (messageInfo is MessageDirPartInfo) {
        // Log.w('文件夹子文件 -> ${messageInfo}');
        if (messageInfo.stat == 'complete') {
          Log.e('完成发送');
          dirMsgMap[messageInfo.partOf].canDownload = true;
          children[dirItemMap[messageInfo.partOf]] =
              MessageItemFactory.getMessageItem(
            dirMsgMap[messageInfo.partOf],
            false,
          );

          update();
        } else {
          dirMsgMap[messageInfo.partOf].fullSize += messageInfo.size ?? 0;
          dirMsgMap[messageInfo.partOf].paths.add(messageInfo.path);
          children[dirItemMap[messageInfo.partOf]] =
              MessageItemFactory.getMessageItem(
            dirMsgMap[messageInfo.partOf],
            false,
          );

          update();
        }
        return;
      } else if (messageInfo is MessageFileInfo) {
        // for (String url in messageInfo.url.split(' ')) {
        //   Uri uri = Uri.parse(url);
        //   Log.d('${uri.scheme}://${uri.host}:7001');
        //   Response response;
        //   try {
        //     response = await httpInstance.get(
        //       '${uri.scheme}://${uri.host}:7001',
        //     );
        //     Log.w(response.data);
        //   } catch (e) {}
        //   if (response != null) {
        //     messageInfo.url = url;
        //   }
        // }
        if (!GetPlatform.isWeb) {
          for (String url in messageInfo.url.split(' ')) {
            Uri uri = Uri.parse(url);
            Log.v('消息带有的address -> ${uri.host}');
            for (String localAddr in addreses) {
              if (uri.host.hasThreePartEqual(localAddr)) {
                Log.d('其中消息的 -> ${uri.host} 与本地的$localAddr 在同一个局域网');
                messageInfo.url = url;
              }
            }
          }
          if (messageInfo.url.contains(' ')) {
            // 这儿是没有找到同一个局域网，有可能划分了子网
            // 相当于提供一个兜底
            for (String url in messageInfo.url.split(' ')) {
              Uri uri = Uri.parse(url);
              Log.v('消息带有的address -> ${uri.host}');
              for (String localAddr in addreses) {
                if (uri.host.hasTwoPartEqual(localAddr)) {
                  Log.d('其中消息的 -> ${uri.host} 与本地的$localAddr 在同一个局域网');
                  messageInfo.url = url;
                }
              }
            }
          }
          if (messageInfo.url.contains(' ')) {
            // 这儿是没有找到同一个局域网，有可能划分了子网
            // 相当于提供一个兜底
            messageInfo.url = messageInfo.url.split(' ').first;
          }
        } else {
          messageInfo.url = messageInfo.url.split(' ').first;
        }
      }
      children.add(MessageItemFactory.getMessageItem(
        messageInfo,
        false,
      ));
      scroll();
      vibrate();
      update();
    });
  }

  Future<void> vibrate() async {
    // 这个用来触发移动端的振动
    for (int i = 0; i < 3; i++) {
      Feedback.forLongPress(Get.context);
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  void getHistoryMsg() {
    // 这个消息来告诉聊天服务器，自己需要历史消息
    print('获取历史消息');
    socket.send(jsonEncode({
      'type': "getHistory",
    }));
  }

  Future<void> scroll() async {
    // 让listview滚动
    await Future.delayed(Duration(milliseconds: 100));
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }

  void sendTextMsg() {
    // 发送文本消息
    MessageTextInfo info = MessageTextInfo(
      content: controller.text,
      msgType: 'text',
    );
    socket.send(info.toString());
    children.add(MessageItemFactory.getMessageItem(
      info,
      true,
    ));
    update();
    controller.clear();
    scroll();
  }
}
