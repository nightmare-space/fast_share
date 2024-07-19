import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide ScreenType;
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart' hide context;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:settings/settings.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/generated/l10n.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/modules/file/file_page.dart';
import 'package:speed_share/modules/widget/header.dart';
import 'package:speed_share/modules/widget/icon.dart';
import 'package:speed_share/modules/preview/image_preview.dart';
import 'package:speed_share/modules/share_chat_window.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/themes/theme.dart';

import 'recent_connect_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    this.onMessageWindowTap,
  }) : super(key: key);
  final void Function()? onMessageWindowTap;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChatController chatController = Get.put(ChatController());
  FileController fileController = Get.find();
  bool serverOpend = true;
  SettingNode privacySetting = 'privacy'.setting;

  // ChatController controller = Get.find();
  bool dropping = false;

  @override
  void initState() {
    super.initState();
    handleSendFile();
    Future.delayed(Duration.zero, () async {
      if (privacySetting.get() == null) {
        await Get.to(PrivacyAgreePage(
          onAgreeTap: () {
            privacySetting.set(true);
            Navigator.of(context).pop();
          },
        ));
        request();
      }
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );
    });
  }

  Future<void> request() async {
    if (GetPlatform.isAndroid) {
      await PermissionUtil.requestStorage();
      // 第一次启动，需要在权限申请后加载一下文件
      fileController.initFile();
    }
  }

  // 处理其他软件过来的分享
  Future<void> handleSendFile() async {
    if (GetPlatform.isAndroid) {
      MethodChannel channel = const MethodChannel('send_channel');
      channel.setMethodCallHandler((call) async {
        if (call.method == 'clip_changed') {
          if (!Global().canShareClip) {
            return;
          }
          if (call.arguments != null) {
            Global().setClipboard(call.arguments);
          } else {
            Global().onClipboardChanged();
          }
        }
        if (call.method == 'send_file') {
          if (call.arguments == null) {
            showToast('分享文件失败');
            return;
          }
          // File file = File.fromUri(Uri.parse(call.arguments));
          // print(file.path);
          Log.d('call -> ${call.arguments}');
          String realPath = call.arguments;
          // realPath = realPath.replaceAll(
          //   RegExp('^/data_app'),
          //   '/data/app',
          // );
          // realPath = realPath.replaceAll(
          //   RegExp('^/525!'),
          //   '/sdcard',
          // );
          // realPath = realPath.replaceAll(
          //   'content://com.nightmare.appmanager.fileprovider/root',
          //   '',
          // );
          Log.d('send_file response realPath => $realPath');
          ChatController controller = Get.find();
          controller.sendFileFromPath(realPath);
        }
      });
    }
  }

  double size = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const Header(),
              SizedBox(height: 16.w),
              chatRoom(context),
              SizedBox(height: 10.w),
              recentFile(context),
              SizedBox(height: 10.w),
              const RecentConnectContainer(),
              SizedBox(height: 10.w),
            ],
          ),
        ),
      ),
    );
  }

  CardWrapper recentFile(BuildContext context) {
    return CardWrapper(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).recentFile,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4.w),
          Expanded(
            child: GetBuilder<FileController>(
              builder: (ctl) {
                List<Widget> children = [];
                for (FileSystemEntity file in ctl.getRecent()) {
                  children.add(
                    SizedBox(
                      width: 60.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getIconByExt(file.path),
                          SizedBox(height: 8.w),
                          SizedBox(
                            height: 20.w,
                            child: Text(
                              basename(file.path),
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 8.w,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  children.add(
                    SizedBox(width: 4.w),
                  );
                }
                if (children.isEmpty) {
                  return Center(
                    child: Text(
                      S.current.empty,
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget chatRoom(BuildContext context) {
    return GestureWithScale(
      onTap: () {
        if (ResponsiveBreakpoints.of(context).isDesktop) {
          widget.onMessageWindowTap?.call();
          return;
        }
        Get.put(ChatController());
        Get.to(() => const ShareChatV2());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(12.w),
        child: GetBuilder<ChatController>(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).chatWindow,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.w),
                Builder(builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 240.w,
                    width: double.infinity,
                    child: Builder(builder: (context) {
                      if (chatController.children.isEmpty) {
                        return Center(
                          child: Text(
                            S.current.chatWindow,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: chatController.children.length,
                        itemBuilder: (c, i) {
                          return chatController.children[i];
                        },
                      );
                    }),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
