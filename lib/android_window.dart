import 'package:android_window/android_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dynamic_island.dart';
import 'generated/l10n.dart';

class AndroidWindowApp extends StatelessWidget {
  const AndroidWindowApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AndroidWindow.setHandler((name, data) async {
      switch (name) {
        case 'hello':
          showSnackBar(context, 'message from main app: $data');
          return 'hello main app';
      }
      return null;
    });
    return AndroidWindow(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DynamicIsland(),
      ),
    );
  }

  showSnackBar(BuildContext context, String title) {
    final snackBar =
        SnackBar(content: Text(title), padding: const EdgeInsets.all(8));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
