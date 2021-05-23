// import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_server/get_server.dart' as get_server;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'app/routes/app_pages.dart';
import 'pages/home_page.dart';
import 'pages/navigator_page.dart';
import 'project.dart';
import 'themes/theme.dart';

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
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (_, Orientation orientation) {
        return GetMaterialApp(
          locale: const Locale('en', 'US'),
          title: '速享',
          initialRoute: SpeedPages.INITIAL,
          getPages: SpeedPages.routes,
          defaultTransition: Transition.fade,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
          builder: (context, child) {
            print('object');
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
