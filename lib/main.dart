import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/home_page.dart';
import 'package:window_manager/window_manager.dart';
import 'app/routes/app_pages.dart';
import 'config/config.dart';
import 'global/global.dart';
import 'themes/default_theme_data.dart';

Future<void> main() async {
  if (!GetPlatform.isWeb && !GetPlatform.isIOS) {
    RuntimeEnvir.initEnvirWithPackageName(Config.packageName);
  }
  runApp(const SpeedShare());
  if (GetPlatform.isDesktop) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      // Hide window title bar
      // await windowManager.setTitleBarStyle('hidden');
      await windowManager.setSize(const Size(500, 300));
      await windowManager.show();
      // await windowManager.setSkipTaskbar(false);
    });
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  // 物理平台使用的udp设备互相发现
  Global().initGlobal();
}

class SpeedShare extends StatelessWidget {
  const SpeedShare({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String initRoute = SpeedPages.initial;
    if (GetPlatform.isWeb) {
      initRoute = Routes.chat;
    }
    return NiToastNew(
      child: OrientationBuilder(
        builder: (_, Orientation orientation) {
          return GetMaterialApp(
            enableLog: false,
            locale: const Locale('en', 'US'),
            title: '速享',
            initialRoute: initRoute,
            getPages: SpeedPages.routes,
            defaultTransition: Transition.fadeIn,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              if (orientation == Orientation.landscape) {
                ScreenAdapter.init(896);
              } else {
                ScreenAdapter.init(414);
              }
              final bool isDark =
                  Theme.of(context).brightness == Brightness.dark;
              final ThemeData theme =
                  isDark ? DefaultThemeData.dark() : DefaultThemeData.light();
              return Theme(
                data: theme,
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}

class SpeedShareEntryPoint extends StatefulWidget {
  SpeedShareEntryPoint({Key key}) : super(key: key) {
    if (RuntimeEnvir.packageName != Config.packageName &&
        !GetPlatform.isDesktop) {
      // 如果这个项目是独立运行的，那么RuntimeEnvir.packageName会在main函数中被设置成Config.packageName
      // 这个 if 就不会走到，如果是被其他的项目依赖，RuntimeEnvir.packageName就会是对应的主仓库的包名
      Config.flutterPackage = 'packages/speed_share/';
    }
  }
  @override
  _SpeedShareEntryPointState createState() => _SpeedShareEntryPointState();
}

class _SpeedShareEntryPointState extends State<SpeedShareEntryPoint> {
  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
