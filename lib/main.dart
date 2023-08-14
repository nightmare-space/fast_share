import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings/settings.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/setting_controller.dart';
import 'package:window_manager/window_manager.dart';
import 'android_window.dart';
import 'app/controller/device_controller.dart';
import 'config/config.dart';
import 'global/global.dart';
import 'material_app_entry_point.dart';
import 'package:file_manager_view/file_manager_view.dart' as fm;
import 'dart:async';

// 初始化hive的设置
Future<void> initSetting() async {
  String path;
  if (GetPlatform.isIOS) {
    path = (await getApplicationDocumentsDirectory()).path;
  } else {
    path = RuntimeEnvir.configPath;
  }
  await initSettingStore(path);
}

// class NoPrint
@pragma('vm:entry-point')
Future<void> androidWindow() async {
  Log.defaultLogger.level = LogLevel.error;
  Log.d("androidWindow");
  Log.v("androidWindow");
  Log.w("androidWindow");
  Log.e("androidWindow");
  Log.i("androidWindow");
  if (!GetPlatform.isWeb && !GetPlatform.isIOS) {
    WidgetsFlutterBinding.ensureInitialized();
    // 拿到应用程序路径
    // get app directory
    final dir = (await getApplicationSupportDirectory()).path;
    RuntimeEnvir.initEnvirWithPackageName(
      Config.packageName,
      appSupportDirectory: dir,
    );
    // 启动文件服务器
    // start file manager server
    fm.Server.start();
  }
  if (!GetPlatform.isWeb) {
    await initSetting();
  }
  Get.put(SettingController());
  Get.put(DeviceController());
  Get.put(ChatController());

  pop = true;
  runApp(const AndroidWindowApp());
  StatusBarUtil.transparent();
}

bool pop = false;

Future<void> main() async {
  runZonedGuarded<void>(
    () async {
      if (!GetPlatform.isWeb) {
        WidgetsFlutterBinding.ensureInitialized();
        // 拿到应用程序路径
        // get app directory
        final dir = (await getApplicationSupportDirectory()).path;
        RuntimeEnvir.initEnvirWithPackageName(
          Config.packageName,
          appSupportDirectory: dir,
        );
        // 启动文件服务器
        // start file manager server
        // todo 肯呢个需要更改成127.0.0.1
        fm.Server.start();
      }
      Get.config(
        enableLog: false,
        logWriterCallback: (text, {isError = false}) {
          // Log.d(text, tag: 'GetX');
        },
      );
      if (!GetPlatform.isWeb) {
        await initSetting();
      }
      Get.put(SettingController());
      Get.put(DeviceController());
      Get.put(ChatController());
      WidgetsFlutterBinding.ensureInitialized();
      if (!GetPlatform.isIOS) {
        String dir;
        if (!GetPlatform.isWeb) {
          dir = (await getApplicationSupportDirectory()).path;
          RuntimeEnvir.initEnvirWithPackageName(
            Config.packageName,
            appSupportDirectory: dir,
          );
        }
      }
      runApp(const SpeedShare());
      // 透明状态栏
      // transparent the appbar
      StatusBarUtil.transparent();
      Future.delayed(Duration(milliseconds: 5000), () {
        Global().initGlobal();
      });
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        Log.e('页面构建异常 : ${details.exception}');
      };
      if (GetPlatform.isDesktop) {
        if (!GetPlatform.isWeb) {
          await windowManager.ensureInitialized();
        }
      }
    },
    (error, stackTrace) {
      Log.e('未捕捉到的异常 : $error \n$stackTrace');
    },
  );
}
