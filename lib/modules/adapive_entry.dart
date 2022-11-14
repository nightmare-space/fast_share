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

  int page;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWrapper.of(context).isDesktop) {
      page ??= GetPlatform.isWeb ? 1 : 0;
      return buildDesktop(context);
    }
    page ??= 0;
    return buildMobile();
  }

  Scaffold buildMobile() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Builder(builder: (context) {
                if (GetPlatform.isWeb) {
                  return [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: const ShareChatV2(),
                      ),
                    ),
                    const SizedBox(),
                    const RemotePage(),
                    const SizedBox(),
                    const FilePage(),
                    const SizedBox(),
                  ][page];
                }
                return [
                  const HomePage(),
                  const RemotePage(),
                  const SizedBox(),
                  const FilePage(),
                  const PersonalPage()
                ][page];
              }),
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
    );
  }

  Scaffold buildDesktop(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DesktopDrawer(
                    value: page,
                    onChange: (value) {
                      page = value;
                      setState(() {});
                    },
                  ),
                  GetBuilder<DeviceController>(builder: (controller) {
                    if (GetPlatform.isWeb) {
                      return Expanded(
                        child: [
                          const SizedBox(),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: const ShareChatV2(),
                            ),
                          ),
                          for (int i = 0;
                              i < controller.connectDevice.length;
                              i++)
                            Builder(
                              builder: (context) {
                                Uri uri = Uri.tryParse(
                                  controller.connectDevice[i].url,
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
                          const SizedBox(),
                          const SizedBox(),
                        ][page],
                      );
                    }
                    return Expanded(
                      child: [
                        HomePage(
                          onMessageWindowTap: () {
                            page = 1;
                            setState(() {});
                          },
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: const ShareChatV2(),
                          ),
                        ),
                        for (int i = 0;
                            i < controller.connectDevice.length;
                            i++)
                          Builder(
                            builder: (context) {
                              Uri uri = Uri.tryParse(
                                controller.connectDevice[i].url,
                              );
                              String addr = 'http://${uri.host}:20000';
                              return FileManager(
                                address: addr,
                                usePackage: true,
                              );
                            },
                          ),
                        const FilePage(),
                        const SettingPage(),
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
}
