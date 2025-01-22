import 'dart:async';
import 'dart:ui';
import 'package:behavior_api/behavior_api.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:multicast/multicast.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/global/tray_handler.dart';
import 'package:speed_share/model/model.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'assets_util.dart';
import 'udp_message_handler.dart';
export 'constant.dart';

/// 主要用来发现局域网的设备
class Global with ClipboardListener, WindowListener {
  Global._internal();
  factory Global() => _getInstance()!;

  static Global? get instance => _getInstance();
  static Global? _instance;

  static Global? _getInstance() {
    _instance ??= Global._internal();
    return _instance;
  }

  Multicast multicast = Multicast();
  String deviceName = '';

  /// 设备的唯一标识
  String uniqueKey = '';

  /// 是否已经初始化
  bool isInit = false;

  //
  TrayHandler trayHandler = TrayHandler();

  @override
  void onClipboardChanged() async {
    SettingController settingController = Get.find();
    if (!settingController.clipboardShare) {
      return;
    }
    ClipboardData? newClipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    Log.i('监听到本机的剪切板:${newClipboardData?.text}');
    ChatController chatController = Get.find();
    ClipboardMessage info = ClipboardMessage(
      content: newClipboardData?.text ?? "",
      sendFrom: Global().deviceName,
    );
    chatController.sendMessage(info);
  }

  bool canShareClip = true;
  void setClipboard(String? text) async {
    Log.i('手动设置剪切板消息:$text');
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

  String tag = 'GlobalInstance';

  // 初始化全局单例
  Future<void> initGlobal() async {
    Log.v('initGlobal', tag: 'GlobalInstance');
    uniqueKey = await UniqueUtil.getUniqueKey();
    deviceName = await UniqueUtil.getDevicesId();
    Log.v('deviceId -> $deviceName', tag: 'GlobalInstance');
    Log.v('uniqueKey -> $uniqueKey', tag: 'GlobalInstance');
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
    // ignore: deprecated_member_use
    FlutterView flutterView = window;
    PlatformDispatcher platformDispatcher = flutterView.platformDispatcher;
    Log.i('当前系统语言 ${platformDispatcher.locales}');
    Log.i('当前系统主题 ${platformDispatcher.platformBrightness}');
    Log.i('physicalSize:${flutterView.physicalSize.str()}');
    Log.i('DP Size:${Get.size.str()}');
    Log.i('devicePixelRatio:${flutterView.devicePixelRatio}');
    Log.i('Android DPI:${flutterView.devicePixelRatio * 160}');
    isInit = true;
    multicast.addListener(receiveUdpMessage);
    if (!GetPlatform.isMobile && !GetPlatform.isWeb) {
      // 注册剪切板观察回调
      clipboardWatcher.addListener(this);
      // 开始监听
      clipboardWatcher.start();
      // 注册任务栏监听
      trayManager.addListener(trayHandler);
      windowManager.addListener(this);
    }
    unpackWebResource();
    await initApi('Speed Share', Config.versionName);
  }

  @override
  void onWindowClose() async {
    windowManager.hide();
    windowManager.setSkipTaskbar(true);
    // windowManager.setProgressBar(0.5);
  }

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}

// 很离谱，编译到 release 下，size.toString 打印的是 Instance of Size
extension SizeExt on Size {
  String str() => 'Size(${width.toStringAsFixed(1)}, ${height.toStringAsFixed(1)})';
}
