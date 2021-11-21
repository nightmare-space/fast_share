import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/pages/item/message_item_factory.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:speed_share/pages/model/model_factory.dart';
import 'package:speed_share/utils/chat_server.dart';
import 'package:speed_share/utils/file_server.dart';
import 'package:speed_share/utils/http/http.dart';
import 'package:speed_share/utils/shelf/static_handler.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:file_selector_nightmare/file_selector_nightmare.dart';
import 'package:speed_share/utils/string_extension.dart';
import 'package:speed_share/utils/unique_util.dart';

class ChatController extends GetxController {
  // 输入框用到的焦点
  FocusNode focusNode = FocusNode();
  // 输入框控制器
  TextEditingController controller = TextEditingController();
  GetSocket socket;
  List<Widget> children = [];
  List<String> addreses = [];
  ScrollController scrollController = ScrollController();
  bool isConnect = false;
  String chatRoomUrl = '';
  // 消息服务器成功绑定的端口
  int successBindPort;
  // 文件服务器成功绑定的端口
  int shelfBindPort;
  int fileServerPort;

  Future<void> initChat(
    bool needCreateChatServer,
    String chatServerAddress,
  ) async {
    Global().disableShowDialog();
    if (!GetPlatform.isWeb) {
      addreses = await PlatformUtil.localAddress();
    }
    if (needCreateChatServer) {
      // 是创建房间的一端
      successBindPort = await createChatServer();
      String udpData = '';
      udpData += await UniqueUtil.getDevicesId();
      udpData += ',$successBindPort';
      Global().startSendBoardcast(udpData);
      chatRoomUrl = 'http://127.0.0.1:$successBindPort';
    } else {
      chatRoomUrl = chatServerAddress;
    }
    socket = GetSocket(chatRoomUrl + '/chat');
    Log.v('chat open');
    Completer conLock = Completer();
    socket.onOpen(() {
      Log.d('chat连接成功');
      isConnect = true;
      if (!conLock.isCompleted) {
        conLock.complete();
      }
    });
    socket.onClose((p0) {
      children.add(MessageItemFactory.getMessageItem(
        MessageTipInfo(content: '所有连接已断开'),
        false,
      ));
      update();
    });
    try {
      socket.connect();
      Future.delayed(Duration(seconds: 2), () {
        // 可能onopen标记完成了
        if (!conLock.isCompleted) {
          conLock.complete();
        }
      });
    } catch (e) {
      conLock.complete();
      isConnect = false;
    }
    await conLock.future;
    if (!isConnect && !GetPlatform.isWeb) {
      // 如果连接失败并且不是 web 平台
      children.add(MessageItemFactory.getMessageItem(
        MessageTextInfo(content: '加入失败!'),
        false,
      ));
      update();
      return;
    }
    if (needCreateChatServer) {
      await sendAddressAndQrCode();
    } else {
      children.add(MessageItemFactory.getMessageItem(
        MessageTextInfo(content: '已加入${chatRoomUrl}'),
        false,
      ));
      update();
    }
    // 监听消息
    listenMessage();
    sendJoinEvent();
    await Future.delayed(Duration(milliseconds: 100));
    getHistoryMsg();
    if (!GetPlatform.isWeb) {
      shelfBindPort = await getSafePort(
        Config.shelfPortRangeStart,
        Config.shelfPortRangeEnd,
      );

      Log.d('shelf will server with $shelfBindPort port');
      serverTokenFile();
      fileServerPort = await getSafePort(
        Config.filePortRangeStart,
        Config.filePortRangeEnd,
      );
      startFileServer(fileServerPort);
      Log.d('file server started with $fileServerPort port');
    }
    Log.w('shelfBindPort -> $shelfBindPort');
  }

  @override
  void onClose() {
    if (isConnect) {
      Log.e('socket.close()');
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
      shelfBindPort,
      shared: true,
    );
  }

  void serverTokenFile() {
    String tokenPath = RuntimeEnvir.filesPath + '/check_token';
    File(tokenPath).writeAsStringSync('success');
    var handler = createFileHandler(
      tokenPath,
      url: 'check_token',
    );
    io.serve(
      handler,
      InternetAddress.anyIPv4,
      shelfBindPort,
      shared: true,
    );
  }

  // 得到正确的url
  Future<String> getCorrectUrl(String preUrl) async {
    for (String url in preUrl.split(' ')) {
      String token = await getToken(url);
      if (token != null) {
        return url;
      }
    }
    return null;
  }

  // 得到正确的url
  Future<String> getCorrectUrlWithAddressAndPort(
    List<String> addresses,
    int port,
  ) async {
    for (String address in addresses) {
      String token = await getToken('http://$address:$port');
      if (token != null) {
        return 'http://$address:$port';
      }
    }
    return null;
  }

  Future<String> getToken(String url) async {
    Log.d('$url/check_token');
    Completer lock = Completer();
    CancelToken cancelToken = CancelToken();
    Response response;
    Future.delayed(Duration(milliseconds: 300), () {
      if (!lock.isCompleted) {
        cancelToken.cancel();
      }
    });
    try {
      response = await httpInstance.get(
        '$url/check_token',
        cancelToken: cancelToken,
      );
      if (!lock.isCompleted) {
        lock.complete(response.data);
      }
      Log.w(response.data);
    } catch (e) {
      if (!lock.isCompleted) {
        lock.complete(null);
      }
      Log.w('$url无法访问');
    }
    return await lock.future;
  }

  //
  Future<void> sendDir() async {
    String dirPath;
    if (GetPlatform.isDesktop) {
      dirPath = await FileSelectorPlatform.instance.getDirectoryPath(
        confirmButtonText: '选择',
      );
    } else {
      dirPath = await FileSelector.pickDirectory(Get.context);
    }
    Log.d('dirPath -> $dirPath');
    if (dirPath == null) {
      return;
    }
    Directory dir = Directory(dirPath);
    String fileUrl = await generateUrlList();
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
    // await for(FileSystemEntity element in  dir.list(recursive: true)){

    // }
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
    //! TODO 这行是测试代码
    await Future.delayed(Duration(seconds: 1));
    socket.send(info.toString());
  }

  Future<void> notifyBroswerUploadFile(String name) async {
    final NotifyMessage notifyMessage = NotifyMessage(
      name: name,
      des: 'now you can upload file which called $name to address []',
      urls: await PlatformUtil.localAddress(),
      port: fileServerPort,
    );
    // 发送消息
    socket.send(notifyMessage.toString());
  }

  // 由于选择文件后并没有第一时间发送，只是发送了一条普通消息
  Map<String, XFile> webFileSendCache = {};
  Future<void> sendFileForBroswer() async {
    final typeGroup = XTypeGroup(
      label: 'images',
      extensions: [''],
    );
    final files = await openFiles(acceptedTypeGroups: [typeGroup]);
    if (files.isEmpty) {
      return;
    }
    for (XFile xFile in files) {
      print('-' * 10);
      print('xFile.path -> ${xFile.path}');
      print('xFile.name -> ${xFile.name}');
      print('xFile.length -> ${await xFile.length()}');
      print('-' * 10);
      // name可能会重复
      webFileSendCache[xFile.name] = xFile;
      final BroswerFileMessage sendFileInfo = BroswerFileMessage(
        fileName: xFile.name,
        fileSize: FileSizeUtils.getFileSize(await xFile.length()),
      );
      // 发送消息
      socket.send(sendFileInfo.toString());
      // 将消息添加到本地列表
      children.add(MessageItemFactory.getMessageItem(
        sendFileInfo,
        true,
      ));
      scroll();
      update();
    }
  }

  Future<void> uploadFileForWeb(XFile xFile, String urlPrefix) async {
    var formData = FormData.fromMap({
      'fileupload': MultipartFile(
        xFile.openRead(),
        await xFile.length(),
        filename: xFile.name,
      ),
    });
    var response = await Dio().post(
      '$urlPrefix/fileupload',
      data: formData,
    );
  }

  Future<void> sendFileForDesktop() async {
    final typeGroup = XTypeGroup(label: 'images');
    final files = await openFiles(acceptedTypeGroups: [typeGroup]);
    if (files.isEmpty) {
      return;
    }
    for (XFile xFile in files) {
      print('-' * 10);
      print('xFile.path -> ${xFile.path}');
      print('xFile.name -> ${xFile.name}');
      print('xFile.length -> ${await xFile.length()}');
      print('-' * 10);
      sendFileFromPath(xFile.path);
    }
  }

  /**
   * useSystemPicker: 是否使用系统文件选择器
   */
  Future<void> sendFileForAndroid({bool useSystemPicker = false}) async {
    // 选择文件路径
    List<String> filePaths = [];
    if (!useSystemPicker) {
      filePaths = await FileSelector.pick(
        Get.context,
      );
    } else {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowCompression: false,
        allowMultiple: true,
      );
      if (result != null) {
        for (PlatformFile file in result.files) {
          filePaths.add(file.path);
        }
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

  // 生成Url列表
  Future<String> generateUrlList() async {
    String fileUrl = '';
    List<String> address = await PlatformUtil.localAddress();
    for (String addr in address) {
      fileUrl += 'http://' + addr + ':$shelfBindPort ';
    }
    return fileUrl.trim();
  }

  // 基于一个文件路径发送消息
  Future<void> sendFileFromPath(String filePath) async {
    serverFile(filePath);
    // 替换windows的路径分隔符
    filePath = filePath.replaceAll('\\', '/');
    // 读取文件大小
    int size = await File(filePath).length();
    // 替换windows盘符
    filePath = filePath.replaceAll(RegExp('^[A-Z]:'), '');
    String fileUrl = await generateUrlList();
    p.Context context;
    if (GetPlatform.isWindows) {
      context = p.windows;
    } else {
      context = p.posix;
    }
    final MessageFileInfo sendFileInfo = MessageFileInfo(
      filePath: filePath,
      fileName: context.basename(filePath),
      fileSize: FileSizeUtils.getFileSize(size),
      url: fileUrl,
    );

    // 发送消息
    socket.send(sendFileInfo.toString());
    // 将消息添加到本地列表
    children.add(MessageItemFactory.getMessageItem(
      sendFileInfo,
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
          MessageTextInfo(content: 'http://$address:$successBindPort'),
          false,
        ));
        // 添加一行二维码消息
        children.add(MessageItemFactory.getMessageItem(
          QRMessage(content: 'http://$address:$successBindPort'),
          false,
        ));
      }
    }
    update();
    scroll();
  }

  Map<String, int> dirItemMap = {};
  Map<String, MessageDirInfo> dirMsgMap = {};

  /// 这个里面的处理相对复杂一点
  void listenMessage() {
    Log.e('监听消息');
    socket.onMessage((message) async {
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
        messageInfo.urlPrifix = await getCorrectUrl(messageInfo.urlPrifix);
        Log.w('dirItemMap -> $dirItemMap');
      } else if (messageInfo is MessageDirPartInfo) {
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
      } else if (messageInfo is NotifyMessage) {
        if (GetPlatform.isWeb) {
          if (webFileSendCache.containsKey(messageInfo.name)) {
            Log.e(messageInfo);
            String url = await getCorrectUrlWithAddressAndPort(
              messageInfo.urls,
              messageInfo.port,
            );
            Log.d('uploadFileForWeb url -> $url');
            uploadFileForWeb(webFileSendCache[messageInfo.name], url);
          }
        }
        return;
      } else if (messageInfo is MessageFileInfo) {
        messageInfo.url = await getCorrectUrl(messageInfo.url);
      }
      // 往聊天列表中添加一条消息
      children.add(MessageItemFactory.getMessageItem(
        messageInfo,
        false,
      ));
      // 自动滑动，振动，更新UI
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

  Future<void> sendJoinEvent() async {
    // 这个消息来告诉聊天服务器，自己需要历史消息
    socket.send(jsonEncode({
      'type': "join",
      'name': await UniqueUtil.getDevicesId(),
    }));
  }

  void getHistoryMsg() {
    // 这个消息来告诉聊天服务器，自己需要历史消息
    print('获取历史消息');
    socket.send(jsonEncode({
      'type': "getHistory",
    }));
  }

  Future<void> scroll() async {
    // 让listview滚动到底部
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
