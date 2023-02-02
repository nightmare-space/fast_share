import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';
import 'package:settings/settings.dart';
import 'package:speed_share/speed_share.dart';

/// 支持切换的语言列表
Map<String, Locale> languageMap = {
  "English": const Locale('en', ''),
  "中文": const Locale('zh', 'CN'),
  "Spanish": const Locale('es', ''),
};

// 管理设置的controller
class SettingController extends GetxController {
  SettingController() {
    if (!GetPlatform.isWeb) {
      initConfig();
    }
  }

  /// 开启自动下载
  bool enableAutoDownload = false;

  /// 开启剪切板共享
  bool clipboardShare = true;

  /// 开启常量岛 const island
  bool enbaleConstIsland = false;

  /// 开启消息振动
  bool vibrate = true;

  /// 开启文件分类
  bool enableFileClassify = false;

  void changeFileClassify(bool value) {
    enableFileClassify = value;
    'enableFileClassify'.set = enableFileClassify;
    update();
  }

  bool enableWebServer = false;

  void changeWebServer(bool value) {
    enableWebServer = value;
    update();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (!isVIP) {
          showToast('这个功能需要会员才能使用哦');
          enableWebServer = !value;
          update();
        } else {
          'enableWebServer'.set = enableWebServer;
        }
      },
    );
  }

  /// 文件储存路径
  String? savePath;

  Locale? currentLocale = const Locale('zh', 'CN');
  String? currentLocaleKey = '中文';

  void switchLanguage(String? key) {
    currentLocaleKey = key;
    'lang'.set = currentLocaleKey;
    currentLocale = languageMap[key];
    update();
  }

  // 初始化配置
  void initConfig() {
    clipboardShare = 'clipboardShare'.get ?? clipboardShare;
    vibrate = 'vibrate'.get ?? vibrate;
    enableAutoDownload = 'enableAutoDownload'.get ?? enableAutoDownload;
    enbaleConstIsland = 'enbaleConstIsland'.get ?? enbaleConstIsland;
    enableFileClassify = 'enableFileClassify'.get ?? enableFileClassify;
    enableWebServer = 'enableWebServer'.get ?? enableWebServer;
    currentLocaleKey = 'lang'.get ?? currentLocaleKey;
    currentLocale = languageMap[currentLocaleKey];
    String defaultPath = '/sdcard/SpeedShare';
    if (GetPlatform.isWindows || GetPlatform.isWeb) {
      defaultPath = '${dirname(Platform.resolvedExecutable)}/SpeedShare';
    }
    savePath = 'savePath'.get ?? defaultPath;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void constIslandChange(bool value) {
    enbaleConstIsland = value;
    'enbaleConstIsland'.set = enbaleConstIsland;
    update();
  }

  void clipChange(bool value) {
    clipboardShare = value;
    'clipboardShare'.set = clipboardShare;
    update();
  }

  void vibrateChange(bool value) {
    vibrate = value;
    'vibrate'.set = vibrate;
    update();
  }

  void enableAutoChange(bool value) {
    enableAutoDownload = value;
    update();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (!isVIP) {
          showToast('这个功能需要会员才能使用哦');
          enableAutoDownload = !value;
          update();
        } else {
          'enableAutoDownload'.set = enableAutoDownload;
        }
      },
    );
  }

  void switchDownLoadPath(String path) {
    savePath = path;
    'savePath'.set = path;
    update();
  }
}
