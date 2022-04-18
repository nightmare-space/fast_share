import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart' hide Router;
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/device_controller.dart';
import 'package:speed_share/app/controller/setting_controller.dart';
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
import 'package:speed_share/utils/shelf/static_handler.dart';
import 'package:speed_share/utils/unique_util.dart';

import 'server_util.dart';

void Function(Null arg) serverFileFunc;

class ChatController extends GetxController {
  ChatController() {
    controller.addListener(() {
      // 这个监听主要是为了改变发送按钮为+号按钮
      if (controller.text.isNotEmpty) {
        hasInput = true;
      } else {
        hasInput = false;
      }
      update();
    });
  }
  // 输入框用到的焦点
  FocusNode focusNode = FocusNode();
  // 输入框控制器
  TextEditingController controller = TextEditingController();
  GetSocket socket;
  List<Widget> fixedChildren = [];
  List<Widget> children = [];
  List<String> addreses = [];
  ScrollController scrollController = ScrollController();
  bool isConnect = false;
  String chatRoomUrl = '';
  // 消息服务器成功绑定的端口
  int chatBindPort;
  // 文件服务器成功绑定的端口
  int shelfBindPort;
  int fileServerPort;
  bool hasInput = false;
  Completer initLock = Completer();
  DeviceController deviceController = Get.find();
  SettingController settingController = Get.find();

  Future<void> createChatRoom() async {
    chatBindPort = await createChatServer();
    Log.i('聊天服务器端口 : $chatBindPort');
    String udpData = '';
    udpData += await UniqueUtil.getDevicesId();
    udpData += ',$chatBindPort';
    // 将设备ID与聊天服务器成功创建的端口UDP广播出去
    Global().startSendBoardcast(udpData);
    chatRoomUrl = 'http://127.0.0.1:$chatBindPort'; // 保存本地的IP地址列表
    if (!GetPlatform.isWeb) {
      addreses = await PlatformUtil.localAddress();
    }
    initChat(chatRoomUrl);
  }

  String chatServerAddress;
  Future<void> initChat(
    String chatServerAddress,
  ) async {
    if (socket != null && chatServerAddress == null) {
      return;
    }
    // if (chatServerAddress != null) {
    //   Global().stopSendBoardcast();
    // }
    if (chatServerAddress == this.chatServerAddress) {
      return;
    }
    this.chatServerAddress = chatServerAddress;

    socket = GetSocket((chatServerAddress ?? chatRoomUrl) + '/chat');
    children.clear();
    Completer conLock = Completer();
    socket.onOpen(() {
      Log.d('chat连接成功');
      isConnect = true;
      if (!conLock.isCompleted) {
        conLock.complete();
      }
    });
    socket.onClose((p0) {
      socket = null;
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
    // if (needCreateChatServer) {
    //   await sendAddressAndQrCode();
    // } else {
    //   children.add(MessageItemFactory.getMessageItem(
    //     MessageTextInfo(content: '已加入$chatRoomUrl'),
    //     false,
    //   ));
    //   update();
    // }
    // 监听消息
    listenMessage();
    sendJoinEvent();
    await Future.delayed(const Duration(milliseconds: 100));
    getHistoryMsg();
    await getSuccessBindPort();
    if (!initLock.isCompleted) {
      initLock.complete();
    }
  }

  Future<void> getSuccessBindPort() async {
    if (!GetPlatform.isWeb) {
      shelfBindPort = await getSafePort(
        Config.shelfPortRangeStart,
        Config.shelfPortRangeEnd,
      );
      Log.i('shelf will server with $shelfBindPort port');
      handleTokenCheck();
      fileServerPort = await getSafePort(
        Config.filePortRangeStart,
        Config.filePortRangeEnd,
      );
      startFileServer(fileServerPort);
      Log.i('file server started with $fileServerPort port');
    }
  }

  @override
  void onClose() {
    if (isConnect) {
      Log.e('socket.close()');
      socket.close();
    }
    Log.e('dispose');
    focusNode.dispose();
    controller.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void handleTokenCheck() {
    // 用来为其他设备检测网络互通的方案
    // 其他设备会通过消息中的IP地址对 `/check_token` 发起 get 请求
    // 如果有响应说明胡互通
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

  // 发起http get请求，用来校验网络是否互通
  // 如果不通，会返回null
  Future<String> getToken(String url) async {
    Log.i('$url/check_token');
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
      Log.i('/check_token 响应 ${response.data}');
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
    // String dirPath;
    // if (GetPlatform.isDesktop) {
    //   dirPath = await FileSelectorPlatform.instance.getDirectoryPath(
    //     confirmButtonText: '选择',
    //   );
    // } else {
    //   dirPath = await FileSelector.pickDirectory(Get.context);
    // }
    // Log.d('dirPath -> $dirPath');
    // if (dirPath == null) {
    //   return;
    // }
    // Directory dir = Directory(dirPath);
    // // 可能会存在两个不同路径下有相同文件夹名的问题
    // String dirName = p.basename(dirPath);
    // // TODO 改Model
    // MessageBaseInfo info = MessageInfoFactory.fromJson({
    //   'dirName': dirName,
    //   'msgType': 'dir',
    //   'urlPrifix': fileUrl,
    //   'fullSize': 0,
    // });
    // // 发送消息
    // socket.send(info.toString());
    // // 将消息添加到本地列表
    // children.add(MessageItemFactory.getMessageItem(
    //   info,
    //   true,
    // ));
    // scroll();
    // update();
    // // await for(FileSystemEntity element in  dir.list(recursive: true)){

    // // }
    // List<FileSystemEntity> list = await dir.list(recursive: true).toList();
    // // TODO
    // // 这儿还不敢随便改，等后面分配时间优化
    // // 不await list，不然在文件特别多的时候，会等待很久
    // list.forEach((element) async {
    //   FileSystemEntity entity = element;
    //   String suffix = '';
    //   int size = 0;
    //   if (entity is Directory) {
    //     suffix = '/';
    //   } else if (entity is File) {
    //     size = await entity.length();
    //     ServerUtil.serveFile(entity.path, shelfBindPort);
    //   }
    //   // TODO 改Model
    //   dynamic info = MessageInfoFactory.fromJson({
    //     'path': element.path + suffix,
    //     'size': size,
    //     'msgType': 'dirPart',
    //     'partOf': dirName,
    //   });
    //   socket.send(info.toString());
    // });
    // // TODO 改Model
    // info = MessageInfoFactory.fromJson({
    //   'stat': 'complete',
    //   // 'size':element.s
    //   'msgType': 'dirPart',
    //   'partOf': dirName,
    // });
    // socket.send(info.toString());
  }

  // 通知web浏览器开始上传文件
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

  // 基于一个文件路径发送消息
  Future<void> sendFileFromPath(String filePath) async {
    await getSuccessBindPort();
    ServerUtil.serveFile(filePath, shelfBindPort);
    // 替换windows的路径分隔符
    filePath = filePath.replaceAll('\\', '/');
    // 读取文件大小
    int size = await File(filePath).length();
    // 替换windows盘符
    filePath = filePath.replaceAll(RegExp('^[A-Z]:'), '');
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
      addrs: addreses,
      port: shelfBindPort,
      sendFrom: Global().deviceId,
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

  Map<String, int> dirItemMap = {};
  Map<String, MessageDirInfo> dirMsgMap = {};
  List<Map<String, dynamic>> cache = [];

  /// 这个里面的处理相对复杂一点
  void listenMessage() {
    Log.i('$this 监听消息');
    socket.onMessage((message) async {
      if (message == '') {
        // 发来的空字符串就没必要解析了
        return;
      }
      Map<String, dynamic> map;
      try {
        map = jsonDecode(message);
        cache.add(map);
        MessageBaseInfo info = MessageInfoFactory.fromJson(map);
        dispatch(info, children);
      } catch (e) {
        return;
      }
    });
  }

  Future<void> dispatch(MessageBaseInfo info, List<Widget> children) async {
    if (info is JoinMessage) {
      if (info.deviceId != await UniqueUtil.getDevicesId()) {
        deviceController.onDeviceConnect(
          info.deviceId,
          info.deviceType,
        );
        update();
      }
    } else if (info is MessageDirInfo) {
      // 保存文件夹消息所在的index
      // dirItemMap[messageInfo.dirName] = children.length;
      // dirMsgMap[messageInfo.dirName] = messageInfo;
      // messageInfo.urlPrifix = await getCorrectUrl(messageInfo.urlPrifix);
      // Log.w('dirItemMap -> $dirItemMap');
    } else if (info is MessageDirPartInfo) {
      if (info.stat == 'complete') {
        Log.e('完成发送');
        dirMsgMap[info.partOf].canDownload = true;
        children[dirItemMap[info.partOf]] = MessageItemFactory.getMessageItem(
          dirMsgMap[info.partOf],
          false,
        );

        update();
      } else {
        dirMsgMap[info.partOf].fullSize += info.size ?? 0;
        dirMsgMap[info.partOf].paths.add(info.path);
        children[dirItemMap[info.partOf]] = MessageItemFactory.getMessageItem(
          dirMsgMap[info.partOf],
          false,
        );

        update();
      }
      return;
    } else if (info is NotifyMessage) {
      if (GetPlatform.isWeb) {
        if (webFileSendCache.containsKey(info.hash)) {
          Log.e(info);
          String url = await getCorrectUrlWithAddressAndPort(
            info.addrs,
            info.port,
          );
          Log.d('uploadFileForWeb url -> $url');
          if (url != null) {
            uploadFileForWeb(webFileSendCache[info.hash], url);
          } else {
            showToast('未检测到可上传IP');
          }
        }
      }
      return;
    } else if (info is MessageFileInfo) {
      String url = await getCorrectUrlWithAddressAndPort(
        info.addrs,
        info.port,
      );
      info.url = url;
      // 这里有种情况，A,B,C三台机器，A创建房间，B加入发送一个文件后退出了速享
      // C加入A的房间，自然是不能再拿到这个文件的信息了
      info.url ??= '';
    }
    // 往聊天列表中添加一条消息
    children.add(MessageItemFactory.getMessageItem(
      info,
      false,
    ));
    // 自动滑动，振动，更新UI
    scroll();
    vibrate();
    update();
  }

  Future<void> vibrate() async {
    if (!settingController.vibrate) {
      return;
    }
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
      'deviceType': type,
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
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease,
      );
    }
  }

  int get type {
    if (GetPlatform.isAndroid) {
      return 0;
    } else if (GetPlatform.isWeb) {
      return 2;
    } else if (GetPlatform.isDesktop) {
      return 1;
    }
    return 3;
  }

  void sendMessage(MessageTextInfo info) {
    info.deviceType = type;
    socket.send(info.toString());
  }

  void sendTextMsg() {
    // 发送文本消息
    MessageTextInfo info = MessageTextInfo(
      content: controller.text,
      sendFrom: Global().deviceId,
    );
    sendMessage(info);
    children.add(MessageItemFactory.getMessageItem(
      info,
      true,
    ));
    update();
    controller.clear();
    scroll();
  }

  List<Widget> backup = [];
  void restoreList() {
    backup.clear();
    update();
  }

  void changeListToDevice(int device) {
    // if (backup.isNotEmpty) {
    //   children = backup;
    // }
    backup.clear();
    for (Map map in cache) {
      MessageBaseInfo info = MessageInfoFactory.fromJson(map);
      if (info is JoinMessage) {
        continue;
      }
      if (info.deviceType == device) {
        dispatch(info, backup);
      }
    }
    // children.removeWhere((element) => element.!=device);
  }
}
