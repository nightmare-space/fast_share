import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('常规'),
            Text('隐私和安全'),
            Text('消息和通知'),
            Text('快捷键'),
            Text('关于速享'),
          ],
        ),
      ),
    );
  }
}
