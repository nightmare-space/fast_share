import 'dart:io';
import 'dart:ui';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_manager_view/file_manager_view.dart' as fm;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/global/constant.dart';
import 'package:speed_share/modules/desktop_drawer.dart';
import 'package:speed_share/modules/file/file_page.dart';
import 'package:speed_share/modules/home/home_page.dart';
import 'package:speed_share/modules/personal/setting/setting_page.dart';
import 'package:speed_share/modules/share_chat_window.dart';
import 'package:path/path.dart' as path;
import 'package:speed_share/themes/app_colors.dart';

class DesktopHome extends StatefulWidget {
  const DesktopHome({Key? key}) : super(key: key);

  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  int page = GetPlatform.isWeb ? 1 : 0;
  ChatController controller = Get.find();
  bool dropping = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) async {
        Log.d('files -> ${detail.files}');
        if (GetPlatform.isAndroid) {
          for (var value in detail.files) {
            Log.w(value.path);
            String filePath = path.fromUri(Uri.parse(value.path).path).replaceAll(
                  '/raw/',
                  '',
                );
            controller.sendFileFromPath(filePath);
            // Log.w(p
            //     .fromUri(Uri.parse(value.path).path)
            //     .replaceAll('/raw/', ''));
          }
        }
        setState(() {});
        if (detail.files.isNotEmpty) {
          // if()
          // Log.d(detail.files.first.runtimeType);
          if (await FileSystemEntity.isDirectory(detail.files.first.path)) {
            // 说明拖拽上来的是一个文件夹
            controller.sendDirFromPath(detail.files.first.path);
          } else {
            controller.sendXFiles(detail.files);
          }
        }
      },
      onDragUpdated: (details) {
        setState(() {
          // offset = details.localPosition;
        });
      },
      onDragEntered: (detail) {
        setState(() {
          dropping = true;
          // offset = detail.localPosition;
        });
      },
      onDragExited: (detail) {
        setState(() {
          dropping = false;
          // offset = null;
        });
      },
      child: Stack(
        children: [
          Scaffold(
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
                                        controller.connectDevice[i].url!,
                                      )!;
                                      String addr = 'http://${uri.host}:${fm.Config.port}';
                                      return fm.FileManager(
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
                                color: Theme.of(context).brightness == Brightness.light ? Colors.white : const Color.fromRGBO(19, 19, 25, 1),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: const ShareChatV2(),
                                ),
                              ),
                              for (int i = 0; i < controller.connectDevice.length; i++)
                                Builder(
                                  builder: (context) {
                                    Uri uri = Uri.tryParse(
                                      controller.connectDevice[i].url!,
                                    )!;
                                    String addr = 'http://${uri.host}:${fm.Config.port}';
                                    return fm.FileManager(
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
          ),
          if (dropping)
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: Material(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    '释放以分享文件到共享窗口~',
                    style: TextStyle(
                      color: AppColors.fontColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.w,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
