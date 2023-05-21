import 'dart:io';
import 'dart:math';

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
  SettingNode enableAutoDownloadSetting = 'enableAutoDownload'.setting;

  /// 开启剪切板共享
  bool clipboardShare = true;
  SettingNode clipboardShareSetting = 'clipboardShare'.setting;

  /// 开启常量岛 const island
  bool enbaleConstIsland = false;
  SettingNode enbaleConstIslandSetting = 'enbaleConstIsland'.setting;

  /// 开启消息振动
  bool vibrate = true;
  SettingNode vibrateSetting = 'vibrate'.setting;

  /// 开启文件分类
  bool enableFileClassify = false;
  SettingNode enableFileClassifySetting = 'enableFileClassify'.setting;
  bool enableWebServer = false;
  SettingNode enableWebServerSetting = 'enableWebServer'.setting;

  void changeFileClassify(bool value) {
    enableFileClassifySetting.set(value);
    enableFileClassify = value;
    update();
  }

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
          enableWebServerSetting.set(value);
        }
      },
    );
  }

  /// 文件储存路径
  String? savePath;
  SettingNode savePathSetting = 'savePath'.setting;

  Locale? currentLocale = const Locale('zh', 'CN');
  String? currentLocaleKey = '中文';
  SettingNode currentLocaleSetting = 'lang'.setting;

  void switchLanguage(String? key) {
    currentLocaleKey = key;
    currentLocaleSetting.set(key);
    currentLocale = languageMap[key];
    update();
  }

  // 初始化配置
  void initConfig() {
    clipboardShare = clipboardShareSetting.get() ?? true;
    vibrate = vibrateSetting.get() ?? true;
    enableAutoDownload = enableAutoDownloadSetting.get() ?? false;
    enbaleConstIsland = enbaleConstIslandSetting.get() ?? false;
    enableFileClassify = enableFileClassifySetting.get() ?? false;
    enableWebServer = enableWebServerSetting.get() ?? false;
    currentLocaleKey = currentLocaleSetting.get() ?? '中文';
    currentLocale = languageMap[currentLocaleKey];
    String defaultPath = '/sdcard/SpeedShare';
    if (GetPlatform.isWindows || GetPlatform.isWeb) {
      defaultPath = '${dirname(Platform.resolvedExecutable)}/SpeedShare';
    }
    savePath = savePathSetting.get() ?? defaultPath;
  }

  void constIslandChange(bool value) {
    enbaleConstIsland = value;
    enbaleConstIslandSetting.set(value);
    update();
  }

  void clipChange(bool value) {
    clipboardShare = value;
    clipboardShareSetting.set(value);
    update();
  }

  void vibrateChange(bool value) {
    vibrate = value;
    vibrateSetting.set(value);
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
          enableAutoDownloadSetting.set(value);
        }
      },
    );
  }

  void switchDownLoadPath(String path) {
    savePath = path;
    savePathSetting.set(path);
    update();
  }
}
