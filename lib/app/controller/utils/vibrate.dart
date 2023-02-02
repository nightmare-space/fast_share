import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_share/app/controller/setting_controller.dart';

Future<void> vibrate() async {
  SettingController settingController = Get.find();
  if (!settingController.vibrate) {
    return;
  }
  // 这个用来触发移动端的振动
  for (int i = 0; i < 3; i++) {
    Feedback.forLongPress(Get.context!);
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
