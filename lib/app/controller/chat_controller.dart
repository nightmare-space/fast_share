import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:global_repository/global_repository.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:speed_share/app/controller/device_controller.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/pages/item/message_item_factory.dart';
import 'package:speed_share/pages/model/join_message.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:speed_share/pages/model/model_factory.dart';
import 'package:speed_share/utils/chat_server.dart';
import 'package:speed_share/utils/file_server.dart';
import 'package:speed_share/utils/http/http.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:file_selector_nightmare/file_selector_nightmare.dart';
import 'package:speed_share/utils/unique_util.dart';
import 'package:speed_share/v2/show_qr_page.dart';

import 'server_util.dart';

void Function(Null arg) serverFileFunc;

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
  bool hasInput = false;
  Completer initLock = Completer();
  bool isInit = false;
  DeviceController deviceController = Get.find();

  Future<void> initChat(
    bool needCreateChatServer,
    String chatServerAddress,
  ) async {
    if (isInit) {
      return;
    }
    isInit = true;
    controller.addListener(() {
      // 这个监听主要是为了改变发送按钮为+号按钮
      if (controller.text.isNotEmpty) {
        hasInput = true;
      } else {
        hasInput = false;
      }
      update();
    });
    if (!GetPlatform.isWeb) {
      addreses = await PlatformUtil.localAddress();
    }
    if (needCreateChatServer) {
      // 是创建房间的一端
      successBindPort = await createChatServer();
      String udpData = '';
      udpData += await UniqueUtil.getDevicesId();
      udpData += ',$successBindPort';
      // 将设备ID与聊天服务器成功创建的端口UDP广播出去
      Global().startSendBoardcast(udpData);
      chatRoomUrl = 'http://127.0.0.1:$successBindPort';
    } else {
      chatRoomUrl = chatServerAddress;
    }
    socket = GetSocket(chatRoomUrl + '/chat');
    Completer conLock = Completer();
    socket.onOpen(() {
      Log.d('chat连接成功');
      isConnect = true;
      if (!conLock.isCompleted) {
        conLock.complete();
      }
    });
    socket.onClose((p0) {
      Log.e('socket onClose $p0');
      children.add(MessageItemFactory.getMessageItem(
        MessageTipInfo(content: '所有连接已断开'),
        false,
      ));
      update();
    });
    try {
      socket.connect();
      Future.delayed(const Duration(seconds: 2), () {
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
    if (!isConnect) {
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
        MessageTextInfo(content: '已加入$chatRoomUrl'),
        false,
      ));
      update();
    }
    if (GetPlatform.isAndroid) {
      children.add(MessageItemFactory.getMessageItem(
        MessageTipInfo(content: '下载路径在 /sdcard/SpeedShare'),
        false,
      ));
      update();
    }
    // 监听消息
    listenMessage();
    sendJoinEvent();
    await Future.delayed(const Duration(milliseconds: 100));
    getHistoryMsg();
    if (!GetPlatform.isWeb) {
      shelfBindPort = await getSafePort(
        Config.shelfPortRangeStart,
        Config.shelfPortRangeEnd,
      );
      Log.d('shelf will server with $shelfBindPort port');
      handleTokenCheck();
      fileServerPort = await getSafePort(
        Config.filePortRangeStart,
        Config.filePortRangeEnd,
      );
      startFileServer(fileServerPort);
      Log.d('file server started with $fileServerPort port');
    }
    Log.w('shelfBindPort -> $shelfBindPort');
    if (!initLock.isCompleted) {
      initLock.complete();
    }
  }

  @override
  void onClose() {
    if (isConnect) {
      Log.e('socket.close()');
      socket.close();
    }
    Log.e('dispose');
    Global().stopSendBoardcast();
    focusNode.dispose();
    controller.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void handleTokenCheck() {
    // 用来为其他设备检测网络互通的方案
    // 其他设备会通过消息中的IP地址对 `/check_token` 发起 get 请求
    // 如果有响应说明胡互通
    var app = Router();
    app.get('/check_token', (shelf.Request request) {
      return shelf.Response.ok('success');
    });

    io.serve(
      app,
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
    Future.delayed(const Duration(milliseconds: 300), () {
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
    // TODO 改Model
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
    // TODO
    // 这儿还不敢随便改，等后面分配时间优化
    // 不await list，不然在文件特别多的时候，会等待很久
    list.forEach((element) async {
      FileSystemEntity entity = element;
      String suffix = '';
      int size = 0;
      if (entity is Directory) {
        suffix = '/';
      } else if (entity is File) {
        size = await entity.length();
        ServerUtil.serveFile(entity.path, successBindPort);
      }
      // TODO 改Model
      dynamic info = MessageInfoFactory.fromJson({
        'path': element.path + suffix,
        'size': size,
        'msgType': 'dirPart',
        'partOf': dirName,
      });
      socket.send(info.toString());
    });
    // TODO 改Model
    info = MessageInfoFactory.fromJson({
      'stat': 'complete',
      // 'size':element.s
      'msgType': 'dirPart',
      'partOf': dirName,
    });
    socket.send(info.toString());
  }

  Future<void> notifyBroswerUploadFile(String hash) async {
    List<String> addresses = await PlatformUtil.localAddress();
    final NotifyMessage notifyMessage = NotifyMessage(
      hash: hash,
      addrs: addresses,
      port: fileServerPort,
    );
    // 发送消息
    socket.send(notifyMessage.toString());
  }

  // 给 web 和桌面端提供的方法
  Future<void> sendXFiles(List<XFile> files) async {
    await initLock.future;
    if (GetPlatform.isWeb) {
      for (XFile xFile in files) {
        Log.w('-' * 10);
        Log.w('xFile.path -> ${xFile.path}');
        Log.w('xFile.name -> ${xFile.name}');
        Log.w('xFile.length -> ${await xFile.length()}');
        Log.w('-' * 10);
        String hash = shortHash(xFile);
        webFileSendCache[hash] = xFile;
        final BroswerFileMessage sendFileInfo = BroswerFileMessage(
          // 用来客户端显示
          fileName: xFile.name,
          hash: hash,
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
    } else if (GetPlatform.isDesktop) {
      for (XFile xFile in files) {
        Log.d('-' * 10);
        Log.d('xFile.path -> ${xFile.path}');
        Log.d('xFile.name -> ${xFile.name}');
        Log.d('xFile.length -> ${await xFile.length()}');
        Log.d('-' * 10);
        sendFileFromPath(xFile.path);
      }
    }
  }

  // 选择文件后并没有第一时间发送，只是发送了一条普通消息
  Map<String, XFile> webFileSendCache = {};
  Future<void> sendFileForBroswerAndDesktop() async {
    List<XFile> files = await getFilesForDesktopAndWeb();
    if (files == null) {
      return;
    }
    sendXFiles(files);
  }

  // web 端速享上传文件调用的方法
  Future<void> uploadFileForWeb(XFile xFile, String urlPrefix) async {
    // var formData = FormData.fromMap({
    //   'file': MultipartFile(
    //     xFile.openRead(),
    //     await xFile.length(),
    //     filename: xFile.name,
    //   ),
    //   'files': [
    //     MultipartFile(
    //       xFile.openRead(),
    //       await xFile.length(),
    //       filename: xFile.name,
    //     ),
    //     MultipartFile(
    //       xFile.openRead(),
    //       await xFile.length(),
    //       filename: xFile.name,
    //     ),
    //   ],
    // });
    await Dio().post(
      '$urlPrefix/file',
      data: xFile.openRead(),
      onSendProgress: (count, total) {
        Log.v('count:$count total:$total pro:${count / total}');
      },
      options: Options(
        headers: {
          Headers.contentLengthHeader: await xFile.length(),
          HttpHeaders.contentTypeHeader: ContentType.binary.toString(),
          'filename': xFile.name,
        },
      ),
    );
  }

  Future<List<XFile>> getFilesForDesktopAndWeb() async {
    final typeGroup = XTypeGroup(
      label: 'images',
      extensions: GetPlatform.isWeb ? [''] : null,
    );
    final files = await openFiles(acceptedTypeGroups: [typeGroup]);
    if (files.isEmpty) {
      return null;
    }
    return files;
  }

  /// useSystemPicker: 是否使用系统文件选择器
  Future<void> sendFileForAndroid({
    bool useSystemPicker = false,
    BuildContext context,
  }) async {
    // 选择文件路径
    List<String> filePaths = [];
    if (!useSystemPicker) {
      filePaths = await FileSelector.pick(
        context ?? Get.context,
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
    if (filePaths == null) {
      return;
    }
    for (String filePath in filePaths) {
      Log.v(filePath);
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
    ServerUtil.serveFile(filePath, successBindPort);
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
    children.add(InkWell(
      onTap: () {
        Get.dialog(ShowQRPage(
          port: successBindPort,
        ));
      },
      child: MessageItemFactory.getMessageItem(
        MessageTextInfo(
          content: '点击查看连接二维码',
        ),
        false,
      ),
    ));

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
      if (messageInfo is JoinMessage) {
        deviceController.onDeviceConnect(messageInfo.deviceId);
        update();
      } else if (messageInfo is MessageDirInfo) {
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
          if (webFileSendCache.containsKey(messageInfo.hash)) {
            Log.e(messageInfo);
            String url = await getCorrectUrlWithAddressAndPort(
              messageInfo.addrs,
              messageInfo.port,
            );
            Log.d('uploadFileForWeb url -> $url');
            if (url != null) {
              uploadFileForWeb(webFileSendCache[messageInfo.hash], url);
            } else {
              showToast('未检测到可上传IP');
            }
          }
        }
        return;
      } else if (messageInfo is MessageFileInfo) {
        messageInfo.url = await getCorrectUrl(messageInfo.url);
        if (messageInfo.url == null) {
          // 这里有种情况，A,B,C三台机器，A创建房间，B加入发送一个文件后退出了速享
          // C加入A的房间，自然是不能再拿到这个文件的信息了
          messageInfo.url = '';
        }
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
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> sendJoinEvent() async {
    // 这个消息来告诉聊天服务器，自己连接上来了
    // 会有一个单独的函数是因为要告诉聊天服务器自己的设备ID
    socket.send(jsonEncode({
      'type': "join",
      'name': GetPlatform.isWeb ? "WEB" : await UniqueUtil.getDevicesId(),
    }));
  }

  void getHistoryMsg() {
    // 这个消息来告诉聊天服务器，自己需要历史消息
    Log.v('获取历史消息');
    socket.send(jsonEncode({
      'type': "getHistory",
    }));
  }

  Future<void> scroll() async {
    // 让listview滚动到底部
    await Future.delayed(const Duration(milliseconds: 100));
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
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
