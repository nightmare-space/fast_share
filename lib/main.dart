import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/home_page.dart';
import 'app/routes/app_pages.dart';
import 'config/config.dart';
import 'global/global.dart';
import 'themes/default_theme_data.dart';
import 'utils/shelf_static.dart';

void main() {
  runApp(SpeedShare());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  RuntimeEnvir.initEnvirWithPackageName('com.nightmare.speedshare');
  if (GetPlatform.isAndroid || GetPlatform.isDesktop && !GetPlatform.isWeb) {
    ShelfStatic.start();
    // ServerUtil.start();
  }
  if (!GetPlatform.isWeb) {
    // 物理平台使用的udp设备互相发现
    Global().initGlobal();
  }
  if (!GetPlatform.isWeb && kReleaseMode) {
    // 解压网页资源
    unpack();
  }
}

Future<void> unpack() async {
  ByteData byteData = await rootBundle.load('assets/web.zip');

  final Uint8List list = byteData.buffer.asUint8List();
  // Decode the Zip file
  final archive = ZipDecoder().decodeBytes(list);

  // Extract the contents of the Zip archive to disk.
  for (final file in archive) {
    final filename = file.name;
    if (file.isFile) {
      final data = file.content as List<int>;
      File wfile = File(RuntimeEnvir.filesPath + '/' + filename);
      await wfile.create(recursive: true);
      await wfile.writeAsBytes(data);
    } else {
      await Directory(RuntimeEnvir.filesPath + '/' + filename)
          .create(recursive: true);
    }
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

class SpeedShareHome extends StatefulWidget {
  SpeedShareHome() {
    if (RuntimeEnvir.packageName != Config.packageName &&
        !GetPlatform.isDesktop) {
      // 如果这个项目是独立运行的，那么RuntimeEnvir.packageName会在main函数中被设置成Config.packageName
      Config.flutterPackage = 'packages/speed_share/';
    }
  }
  @override
  _SpeedShareHomeState createState() => _SpeedShareHomeState();
}

class _SpeedShareHomeState extends State<SpeedShareHome> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
