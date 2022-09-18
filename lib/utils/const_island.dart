// 常量岛
import 'dart:ui';

import 'package:android_window/main.dart';
import 'package:get/get.dart';

class ConstIsland {
  // 当剪切板消息收到的时候
  static void onClipboardReceive(String deviceName) {
    Size size = Get.size;
    open(
      size: Size(size.width * window.devicePixelRatio, 800),
      position: const Offset(0, 0),
      focusable: true,
    );
    Future.delayed(const Duration(milliseconds: 10), () async {
      final response = await post(
        'hello',
        '已复制$deviceName的剪切板',
      );
    });
  }

  static void onFileReceive() {}
  // static void onFileReceive() {}
}
