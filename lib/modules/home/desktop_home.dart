import 'package:file_manager_view/file_manager_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/global/constant.dart';
import 'package:speed_share/modules/desktop_drawer.dart';
import 'package:speed_share/modules/file/file_page.dart';
import 'package:speed_share/modules/home/home_page.dart';
import 'package:speed_share/modules/setting/setting_page.dart';
import 'package:speed_share/modules/share_chat_window.dart';
import 'package:speed_share/themes/theme.dart';

class DesktopHome extends StatefulWidget {
  const DesktopHome({Key key}) : super(key: key);

  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  int page = GetPlatform.isWeb ? 1 : 0;

  @override
  Widget build(BuildContext context) {
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
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: const ShareChatV2(),
                            ),
                          ),
                          for (int i = 0; i < controller.connectDevice.length; i++)
                            Builder(
                              builder: (context) {
                                Uri uri = Uri.tryParse(
                                  controller.connectDevice[i].url,
                                );
                                String addr = 'http://${uri.host}:20000';
                                return FileManager(
                                  address: addr,
                                  usePackage: true,
                                  path: controller.connectDevice[i].deviceType == desktop ? '/User' : '/sdcard',
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
                          color: Theme.of(context).brightness == Brightness.light ? Colors.white : Color.fromRGBO(19, 19, 25, 1),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: const ShareChatV2(),
                          ),
                        ),
                        for (int i = 0; i < controller.connectDevice.length; i++)
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
