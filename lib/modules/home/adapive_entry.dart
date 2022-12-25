// 响应式布局
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:file_manager_view/file_manager_view.dart';
import 'package:speed_share/global/constant.dart';

import '../desktop_drawer.dart';
import '../file/file_page.dart';
import 'desktop_home.dart';
import 'home_page.dart';
import 'mobile_home.dart';
import 'nav.dart';
import '../personal/personal.dart';
import '../remote_page.dart';
import '../setting/setting_page.dart';
import '../share_chat_window.dart';

// 自动响应布局
class AdaptiveEntryPoint extends StatefulWidget {
  const AdaptiveEntryPoint({
    Key key,
  }) : super(key: key);

  @override
  State<AdaptiveEntryPoint> createState() => _AdaptiveEntryPointState();
}

class _AdaptiveEntryPointState extends State<AdaptiveEntryPoint> {
  ChatController chatController = Get.put(ChatController());
  String address;

  @override
  void initState() {
    super.initState();
    if (!GetPlatform.isWeb) {
      chatController.createChatRoom();
    } else {
      chatController.initChat();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWrapper.of(context).isDesktop) {
      return const DesktopHome();
    }
    return const MobileHome();
  }
}
