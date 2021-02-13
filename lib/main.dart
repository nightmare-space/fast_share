import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/utils/proxy.dart';
import 'pages/home_page.dart';
import 'pages/setting_page.dart';
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
    return MaterialApp(
      title: '速享',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            headline6: TextStyle(
              height: 1.0,
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        primarySwatch: Colors.blue,
      ),
      home: NiToastNew(
        child: SpeedShare(),
      ),
    );
  }
}

class NiNavigator {
  NiNavigator.of(this.context);
  final BuildContext context;
  Future<T> push<T>(Widget page) async {
    return await Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        builder: (_) {
          return page;
        },
      ),
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
    return OrientationBuilder(
      builder: (_, Orientation orientation) {
        print('刷新 orientation ->$orientation');
        if (kIsWeb || Platform.isMacOS) {
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
          child: HomePage(),
        );
      },
    );
  }
}
