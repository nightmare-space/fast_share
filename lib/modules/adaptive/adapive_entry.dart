// 响应式布局
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:signale/signale.dart';
import 'package:speed_share/app/controller/controller.dart';

import '../home/desktop_home.dart';
import '../home/mobile_home.dart';

// 自动响应布局
class AdaptiveEntryPoint extends StatefulWidget {
  const AdaptiveEntryPoint({
    Key? key,
  }) : super(key: key);

  @override
  State<AdaptiveEntryPoint> createState() => _AdaptiveEntryPointState();
}

class _AdaptiveEntryPointState extends State<AdaptiveEntryPoint> {
  ChatController chatController = Get.put(ChatController());
  String? address;

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
    // return SizedBox();
    if (ResponsiveBreakpoints.of(context).isDesktop) {
      Log.i('$this is desktop');
      return const DesktopHome();
    }
    Log.i('$this is mobile');
    return const MobileHome();
  }
}
