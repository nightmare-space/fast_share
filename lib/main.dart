import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:settings/settings.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/setting_controller.dart';
import 'package:window_manager/window_manager.dart';
import 'app/controller/device_controller.dart';
import 'app/routes/app_pages.dart';
import 'config/config.dart';
import 'global/global.dart';
import 'themes/default_theme_data.dart';
import 'package:file_manager_view/file_manager_view.dart' as fm;

// 初始化hive的设置
Future<void> initSetting() async {
  await initSettingStore(RuntimeEnvir.configPath);
}

Future<void> main() async {
  if (!GetPlatform.isWeb && !GetPlatform.isIOS) {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = (await getApplicationSupportDirectory()).path;
    RuntimeEnvir.initEnvirWithPackageName(
      Config.packageName,
      appSupportDirectory: dir,
    );
    fm.Server.start();
  }
  Get.config(
    logWriterCallback: (text, {isError}) {
      Log.d(text, tag: 'GetX');
    },
  );
  if (!GetPlatform.isWeb) {
    await initSetting();
  }
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(DeviceController());
  Get.put(SettingController());
  runApp(const SpeedShare());
  if (GetPlatform.isDesktop) {
    if (!GetPlatform.isWeb) {
      await windowManager.ensureInitialized();
    }
  }
  // 透明状态栏
  StatusBarUtil.transparent();
  // 物理平台使用的udp设备互相发现
  Global().initGlobal();
}

class SpeedShare extends StatelessWidget {
  const SpeedShare({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String initRoute = SpeedPages.initial;
    ChatController controller = Get.put(ChatController());
    if (GetPlatform.isWeb) {
      initRoute = Routes.chat;
    }
    return ToastApp(
      child: Stack(
        children: [
          GetMaterialApp(
            locale: const Locale('zh', 'CN'),
            title: '速享',
            initialRoute: initRoute,
            getPages: SpeedPages.routes,
            defaultTransition: Transition.fadeIn,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              final bool isDark =
                  Theme.of(context).brightness == Brightness.dark;
              final ThemeData theme =
                  isDark ? DefaultThemeData.dark() : DefaultThemeData.light();
              return ResponsiveWrapper.builder(
                Builder(builder: (context) {
                  if (ResponsiveWrapper.of(context).isDesktop) {
                    ScreenAdapter.init(896);
                  } else {
                    ScreenAdapter.init(414);
                  }
                  return Theme(
                    data: theme,
                    child: child,
                  );
                }),
                // maxWidth: 1200,
                minWidth: 480,
                defaultScale: false,
                breakpoints: const [
                  ResponsiveBreakpoint.resize(300, name: MOBILE),
                  ResponsiveBreakpoint.autoScale(600, name: TABLET),
                  ResponsiveBreakpoint.resize(600, name: DESKTOP),
                ],
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: controller.connectState,
            builder: (_, value, __) {
              return Container(
                height: 2.w,
                decoration: BoxDecoration(
                  color: value ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(16.w),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
