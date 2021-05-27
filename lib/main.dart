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
import 'pages/navigator_page.dart';
import 'themes/theme.dart';

import 'utils/document/document.dart';

void main() {
  // startProxy();
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  if (GetPlatform.isAndroid) {
    RuntimeEnvir.initEnvirWithPackageName('com.nightmare.speedshare');
  }
  if (GetPlatform.isDesktop && !GetPlatform.isWeb) {
    RuntimeEnvir.initEnvirForDesktop();
  }
  unpack();
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String initRoute = SpeedPages.INITIAL;
    if (GetPlatform.isWeb) {
      Uri uri = Uri.parse(url);
      initRoute =
          '/chat?needCreateChatServer=false&chatServerAddress=http://${uri.host}:${uri.port}';
    }
    return OrientationBuilder(
      builder: (_, Orientation orientation) {
        return GetMaterialApp(
          locale: const Locale('en', 'US'),
          title: '速享',
          initialRoute: initRoute,
          getPages: SpeedPages.routes,
          defaultTransition: Transition.fade,
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
            // // config中的Dimens获取不到ScreenUtil，因为ScreenUtil中用到的MediaQuery只有在
            // // WidgetApp或者MaterialApp中才能获取到，所以在build方法中处理主题
            final bool isDark = Theme.of(context).brightness == Brightness.dark;
            final ThemeData theme =
                isDark ? DefaultThemeData.dark() : DefaultThemeData.light();
            return Theme(
              data: theme,
              child: NiToastNew(
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}

class SpeedShare extends StatefulWidget {
  @override
  _SpeedShareState createState() => _SpeedShareState();
}

class _SpeedShareState extends State<SpeedShare> {
  @override
  Widget build(BuildContext context) {
    return NavigatorPage();
  }
}
