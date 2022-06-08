// 响应式布局
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:file_manager_view/file_manager_view.dart';
import 'package:speed_share/global/constant.dart';

import 'desktop_drawer.dart';
import 'file/file_page.dart';
import 'home/home_page.dart';
import 'home/nav.dart';
import 'personal/personal.dart';
import 'remote_page.dart';
import 'setting/setting_page.dart';
import 'share_chat_window.dart';

// 自动响应布局
class AdaptiveEntryPoint extends StatefulWidget {
  const AdaptiveEntryPoint({
    Key key,
    this.address,
  }) : super(key: key);
  final String address;

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
      chatController.initChat(widget.address);
    }
  }

  int page = GetPlatform.isWeb ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWrapper.of(context).isDesktop) {
      return Scaffold(
        body: SafeArea(
          left: false,
          child: Column(
            children: [
              Container(
                height: 1.w,
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Row(
                  children: [
                    DesktopDrawer(
                      value: page,
                      onChange: (value) {
                        page = value;
                        setState(() {});
                      },
                    ),
                    GetBuilder<DeviceController>(builder: (controller) {
                      return Expanded(
                        child: [
                          if (!GetPlatform.isWeb)
                            HomePage(
                              onMessageWindowTap: () {
                                page = 1;
                                setState(() {});
                              },
                              onJoinRoom: (value) {
                                address = value;
                                page = 1;
                                setState(() {});
                              },
                            )
                          else
                            const SizedBox(),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: ShareChatV2(
                                chatServerAddress: widget.address ?? address,
                              ),
                            ),
                          ),
                          for (int i = 0;
                              i < controller.connectDevice.length;
                              i++)
                            Builder(
                              builder: (context) {
                                Uri uri = Uri.tryParse(
                                  controller.connectDevice[i].address,
                                );
                                String addr = 'http://${uri.host}:20000';
                                return FileManager(
                                  address: addr,
                                  usePackage: true,
                                  path:
                                      controller.connectDevice[i].deviceType ==
                                              desktop
                                          ? '/User'
                                          : '/sdcard',
                                );
                              },
                            ),
                          if (!GetPlatform.isWeb)
                            const FilePage()
                          else
                            const SizedBox(),
                          if (!GetPlatform.isWeb)
                            const SettingPage()
                          else
                            const SizedBox(),
                        ][page],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: [
                      if (GetPlatform.isWeb)
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: ShareChatV2(
                              chatServerAddress: widget.address ?? address,
                            ),
                          ),
                        )
                      else
                        const HomePage(),
                      if (GetPlatform.isWeb) const SizedBox(),
                      const RemotePage(),
                      const SizedBox(),
                      const FilePage(),
                      if (!GetPlatform.isWeb)
                        const PersonalPage()
                      else
                        const SizedBox(),
                    ][page],
                  ),
                  Nav(
                    value: page,
                    onTap: (value) {
                      page = value;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
