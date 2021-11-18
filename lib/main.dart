import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/home_page.dart';
import 'package:speed_share/utils/http/http.dart';
import 'app/routes/app_pages.dart';
import 'config/config.dart';
import 'global/global.dart';
import 'themes/default_theme_data.dart';
import 'utils/shelf_static.dart';

void main() {
  if (!GetPlatform.isWeb) {
    RuntimeEnvir.initEnvirWithPackageName('com.nightmare.speedshare');
  }
  runApp(SpeedShare());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  // 物理平台使用的udp设备互相发现
  Global().initGlobal();
  // test();
}

Future<void> test() async {
  while (true) {
    DateTime now = DateTime.now();
    Log.w('$now');
    try {
      await Log.w((await httpInstance.get(
        'https://nightmare.fun',
      ))
          .data);
    } catch (e) {}
    await Future.delayed(Duration(milliseconds: 800));
  }
}

class SpeedShare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String initRoute = SpeedPages.INITIAL;
    if (GetPlatform.isWeb) {
      initRoute = '/chat';
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
  SpeedShareEntryPoint() {
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
    return HomePage();
  }
}
