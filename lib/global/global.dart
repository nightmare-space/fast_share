import 'dart:async';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:multicast/multicast.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/global/tray_handler.dart';
import 'package:speed_share/model/model.dart';
import 'package:speed_share/utils/unique_util.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'assets_util.dart';
import 'udp_message_handler.dart';
export 'constant.dart';

/// 主要用来发现局域网的设备
class Global with ClipboardListener, WindowListener {
  Global._internal();
  factory Global() => _getInstance();

  static Global get instance => _getInstance();
  static Global _instance;

  static Global _getInstance() {
    _instance ??= Global._internal();
    return _instance;
  }

  Multicast multicast = Multicast();
  String deviceId = '';

  /// 是否已经初始化
  bool isInit = false;

  // Widget header;

  //
  TrayHandler trayHandler = TrayHandler();

  @override
  void onClipboardChanged() async {
    // TODO，应该先读设置开关
    ClipboardData newClipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    Log.i('剪切板来啦:${newClipboardData?.text}' ?? "");
    ChatController chatController = Get.find();
    ClipboardMessage info = ClipboardMessage(
      content: newClipboardData?.text ?? "",
      sendFrom: Global().deviceId,
    );
    chatController.sendMessage(info);
  }

  bool canShareClip = true;
  void setClipboard(String text) async {
    Log.i('手动设置剪切板消息:$text' ?? "");
    ChatController chatController = Get.find();
    ClipboardMessage info = ClipboardMessage(
      content: text ?? "",
    );
    // 写入剪切板 会触发 onClipboardChanged造成死循环
    // await Clipboard.setData(ClipboardData(text: text));
    chatController.sendMessage(info);
  }

  // udp广播消息列表
  List<String> boardcasdMessage = [];

  Future<void> startSendBoardcast(String data) async {
    if (!boardcasdMessage.contains(data)) {
      boardcasdMessage.add(data);
    }
    multicast.startSendBoardcast(boardcasdMessage);
  }

  Future<void> stopSendBoardcast() async {
    multicast.stopSendBoardcast();
  }

  // 初始化全局单例
  Future<void> initGlobal() async {
    Log.v('initGlobal', tag: 'GlobalInstance');
    deviceId = await UniqueUtil.getDevicesId();
    if (GetPlatform.isWeb || GetPlatform.isIOS) {
      // web udp 和部署都不支持
      return;
    }
    if (isInit) {
      return;
    }
    if (RuntimeEnvir.packageName != Config.packageName && !GetPlatform.isDesktop) {
      // 如果这个项目是独立运行的，那么RuntimeEnvir.packageName会在main函数中被设置成Config.packageName
      // 这个 if 就不会走到，如果是被其他的项目依赖，RuntimeEnvir.packageName就会是对应的主仓库的包名
      Config.flutterPackage = 'packages/speed_share/';
      Config.package = 'speed_share';
    }
    isInit = true;
    multicast.addListener(receiveUdpMessage);
    if (!GetPlatform.isMobile) {
      // 注册剪切板观察回调
      clipboardWatcher.addListener(this);
      // 开始监听
      clipboardWatcher.start();
      // 注册任务栏监听
      trayManager.addListener(trayHandler);
      windowManager.addListener(this);
    }
    unpackWebResource();
  }

  @override
  void onWindowClose() async {
    windowManager.hide();
    windowManager.setSkipTaskbar(true);
    // windowManager.setProgressBar(0.5);
  }
}
