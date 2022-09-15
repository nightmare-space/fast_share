import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:multicast/multicast.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/app/controller/utils/join_util.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/model/model.dart';
import 'package:speed_share/utils/unique_util.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import 'assets_util.dart';
import 'udp_message_handler.dart';

/// 主要用来发现局域网的设备
class Global with ClipboardListener, TrayListener, WindowListener {
  factory Global() => _getInstance();

  Global._internal();

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

  // /// 接收广播消息
  @override
  void onClipboardChanged() async {
    ClipboardData newClipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    Log.i('剪切板来啦:${newClipboardData?.text}' ?? "");
    ChatController chatController = Get.find();
    ClipboardMessage info = ClipboardMessage(
      content: newClipboardData?.text ?? "",
      sendFrom: Global().deviceId,
    );
    chatController.sendMessage(info);
  }

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

  void getclipboard() {
    // Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    //   SettingController settingController = Get.put(SettingController());
    //   if (!settingController.clipboardShare) {
    //     return;
    //   }
    //   ClipboardData clip = await Clipboard.getData(Clipboard.kTextPlain);
    //   if (clip != null && clip.text != localClipdata) {
    //     localClipdata = clip.text;
    //     Log.i('ClipboardData ： ${clip.text}');
    //     stopSendBoardcast();
    //     startSendBoardcast('clip${clip.text}');
    //     Future.delayed(const Duration(seconds: 3), () {
    //       stopSendBoardcast();
    //       boardcasdMessage.remove('clip${clip.text}');
    //       multicast.startSendBoardcast(boardcasdMessage);
    //     });
    //   }
    // });
  }

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
    if (RuntimeEnvir.packageName != Config.packageName &&
        !GetPlatform.isDesktop) {
      // 如果这个项目是独立运行的，那么RuntimeEnvir.packageName会在main函数中被设置成Config.packageName
      // 这个 if 就不会走到，如果是被其他的项目依赖，RuntimeEnvir.packageName就会是对应的主仓库的包名
      Config.flutterPackage = 'packages/speed_share/';
      Config.package = 'speed_share';
    }
    isInit = true;
    multicast.addListener(receiveUdpMessage);
    getclipboard();
    if (GetPlatform.isDesktop) {
      clipboardWatcher.addListener(this);
      clipboardWatcher.start();

      await trayManager.setIcon(
        'assets/icon/ic_launcher.png',
      );
      Menu menu = Menu(
        items: [
          MenuItem(
            key: 'show_window',
            label: 'Show Window',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'exit_app',
            label: 'Exit App',
          ),
        ],
      );
      await trayManager.setContextMenu(menu);
      trayManager.addListener(this);
      windowManager.addListener(this);
    }
    unpackWebResource();
  }

  @override
  void onTrayIconMouseDown() {
    // do something, for example pop up the menu
    windowManager.show();
    windowManager.setSkipTaskbar(false);
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
    // do something
  }

  @override
  void onTrayIconRightMouseUp() {
    // do something
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show_window') {
      windowManager.show();
      windowManager.setSkipTaskbar(false);
      // do something
    } else if (menuItem.key == 'exit_app') {
      windowManager.destroy();
      // do something
    }
  }

  @override
  void onWindowClose() async {
    windowManager.hide();
    windowManager.setSkipTaskbar(true);
    // windowManager.setProgressBar(0.5);
  }
}
