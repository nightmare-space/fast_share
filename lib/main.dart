import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'app/routes/app_pages.dart';
import 'config/config.dart';
import 'global/global.dart';
import 'pages/navigator_page.dart';
import 'themes/theme.dart';

import 'utils/auth.dart';
import 'utils/document/document.dart';

void main() {
  // startProxy();
  runApp(SpeedShare());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  if (GetPlatform.isAndroid && !GetPlatform.isWeb) {
    RuntimeEnvir.initEnvirWithPackageName('com.nightmare.speedshare');
  }
  if (GetPlatform.isDesktop && !GetPlatform.isWeb) {
    RuntimeEnvir.initEnvirForDesktop();
    // HttpServerUtil.bindServer();
  }
  if (!GetPlatform.isWeb) {
    Global().initGlobal();
  }
  if (!GetPlatform.isWeb && kReleaseMode) {
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String initRoute = SpeedPages.INITIAL;
    if (GetPlatform.isWeb) {
      initRoute = '/chat';
    }
    return OrientationBuilder(
      builder: (_, Orientation orientation) {
        return GetMaterialApp(
          enableLog: false,
          locale: const Locale('en', 'US'),
          title: '速享',
          initialRoute: initRoute,
          getPages: SpeedPages.routes,
          defaultTransition: Transition.fadeIn,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
          builder: (context, child) {
            if (kIsWeb || GetPlatform.isDesktop) {
              ScreenUtil.init(
                context,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                allowFontScaling: false,
              );
            } else {
              if (orientation == Orientation.landscape) {
                ScreenUtil.init(
                  context,
                  width: 896,
                  height: 414,
                  allowFontScaling: false,
                );
              } else {
                ScreenUtil.init(
                  context,
                  width: 414,
                  height: 896,
                  allowFontScaling: false,
                );
              }
            }
            return child;
          },
        );
      },
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
    return NavigatorPage();
  }
}
