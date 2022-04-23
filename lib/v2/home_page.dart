import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide ScreenType;
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/device_controller.dart';
import 'package:speed_share/app/controller/file_controller.dart';
import 'package:speed_share/app/routes/app_pages.dart';
import 'package:speed_share/pages/online_list.dart';
import 'package:speed_share/v2/desktop_drawer.dart';
import 'package:speed_share/v2/file_page.dart';
import 'package:speed_share/v2/preview_image.dart';
import 'package:speed_share/v2/setting_page.dart';

import 'header.dart';
import 'icon.dart';
import 'nav.dart';
import 'remote_page.dart';
import 'share_chat_window.dart';

// 响应式布局
class AdaptiveEntryPoint extends StatefulWidget {
  const AdaptiveEntryPoint({Key key}) : super(key: key);

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
    }
  }

  int page = 0;

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
                          ),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: ShareChatV2(
                                chatServerAddress: address,
                              ),
                            ),
                          ),
                          for (int i = 0;
                              i < controller.connectDevice.length;
                              i++)
                            Builder(builder: (context) {
                              Uri uri = Uri.tryParse(
                                  controller.connectDevice[i].address);
                              String addr = 'http://${uri.host}:20000';
                              return Container(
                                color: Colors.white,
                                child: WebSpeedShareEntry(
                                  address: address,
                                  fileAddress: addr,
                                ),
                              );
                            }),
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: [
                const HomePage(),
                const RemotePage(),
                const SizedBox(),
                const FilePage(),
                const SettingPage(),
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
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    this.onMessageWindowTap,
    this.onJoinRoom,
  }) : super(key: key);
  final void Function() onMessageWindowTap;
  final void Function(String address) onJoinRoom;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChatController chatController = Get.put(ChatController());
  FileController fileController = Get.find();
  bool serverOpend = true;
  // ChatController controller = Get.find();
  bool dropping = false;

  @override
  void initState() {
    super.initState();
    request();
    handleSendFile();
  }

  Future<void> request() async {
    if (GetPlatform.isAndroid) {
      PermissionUtil.requestStorage();
    }
  }

  // 处理其他软件过来的分享
  // TODO 冷启动分享
  Future<void> handleSendFile() async {
    if (GetPlatform.isAndroid) {
      MethodChannel channel = const MethodChannel('send_channel');
      channel.setMethodCallHandler((call) async {
        if (call.method == 'send_file') {
          // File file = File.fromUri(Uri.parse(call.arguments));
          // print(file.path);
          Log.d('call -> ${call.arguments}');
          String realPath = call.arguments.toString().replaceAll('file://', '');
          realPath = realPath.replaceAll(
            'content://com.miui.home.fileprovider/data_app',
            '/data/app',
          );
          realPath = realPath.replaceAll(
            'content://com.nightmare.appmanager.fileprovider/root',
            '',
          );
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: OverlayStyle.dark,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                buildHead(context),
                SizedBox(height: 12.w),
                OnlineList(onJoin: widget.onJoinRoom),
                SizedBox(height: 4.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 8.w,
                    horizontal: 8.w,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '最近图片',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(height: 4.w),
                        Container(
                          color: const Color(0xffE0C4C4).withOpacity(0.2),
                          height: 1,
                        ),
                        GetBuilder<FileController>(builder: (context) {
                          File file = fileController.getRecentImage();
                          if (file == null) {
                            return const SizedBox();
                          }
                          String unique = shortHash(() {});
                          return GestureWithScale(
                            onTap: () {
                              Get.to(PreviewImage(
                                path: file.path,
                                tag: unique,
                              ));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Hero(
                                tag: unique,
                                child: Image.file(
                                  file,
                                  width: double.infinity,
                                  height: 120.w,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.w),
                onknownFile(context),
                SizedBox(height: 10.w),
                allDevice(context),
                SizedBox(height: 10.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(10.w),
                  child: GetBuilder<ChatController>(builder: (_) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '远程访问',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(height: 4.w),
                        Container(
                          color: const Color(0xffE0C4C4).withOpacity(0.2),
                          height: 1,
                        ),
                        SizedBox(height: 4.w),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 100.w,
                          width: double.infinity,
                          padding: EdgeInsets.all(8.w),
                          child: ListView.builder(
                            itemCount: chatController.addrs.length,
                            itemBuilder: (context, index) {
                              return SelectableText(
                                'http://${chatController.addrs[index]}:12000/',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                // SizedBox(height: 10.w),
                // GetBuilder<DeviceController>(builder: (_) {
                //   List<Widget> children = [];
                //   DeviceController deviceController = Get.find();
                //   for (Device device
                //       in deviceController.connectDevice) {
                //     children.add(
                //       Container(
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         height: 126.w,
                //         padding: EdgeInsets.all(10.w),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               device.deviceName.toString(),
                //               style: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 color: Theme.of(context)
                //                     .colorScheme
                //                     .onBackground,
                //               ),
                //             ),
                //             SizedBox(
                //               height: 4.w,
                //             ),
                //             Container(
                //               color: const Color(0xffE0C4C4)
                //                   .withOpacity(0.2),
                //               height: 1,
                //             ),
                //             SizedBox(
                //               height: 4.w,
                //             ),
                //             Text(
                //               '如果有新的设备链接，会在下方添加新的设备版块，在首页手指向上滑动，可以拖动。',
                //               style: TextStyle(
                //                 color: Theme.of(context)
                //                     .colorScheme
                //                     .onBackground,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //     children.add(SizedBox(
                //       height: 8.w,
                //     ));
                //   }
                //   return Column(
                //     children: children,
                //   );
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CardWrapper onknownFile(BuildContext context) {
    return CardWrapper(
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '最近文件',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          SizedBox(height: 4.w),
          Container(
            color: const Color(0xffE0C4C4).withOpacity(0.2),
            height: 1,
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
                                color: Colors.black,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  children.add(
                    SizedBox(
                      width: 4.w,
                    ),
                  );
                }
                if (children.isEmpty) {
                  return Center(
                    child: Text(
                      '空',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Colors.black54,
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

  GestureDetector allDevice(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ResponsiveWrapper.of(context).isDesktop) {
          widget.onMessageWindowTap?.call();
          return;
        }
        Get.put(ChatController());
        Get.to(const WebSpeedShareEntry(
          padding: EdgeInsets.zero,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(10.w),
        child: GetBuilder<ChatController>(builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '消息窗口(以前点那个+号打开的页面)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              SizedBox(height: 4.w),
              Container(
                color: const Color(0xffE0C4C4).withOpacity(0.2),
                height: 1,
              ),
              SizedBox(height: 4.w),
              Builder(builder: (context) {
                // Log.i(chatController.children..last);
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 100.w,
                  width: double.infinity,
                  child: Builder(builder: (context) {
                    if (chatController.children.isEmpty) {
                      return Center(
                        child: Text(
                          '当前没有任何消息，点击进入到消息列表',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      // controller: chatController.scrollController,
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
        }),
      ),
    );
  }

  Widget buildHead(BuildContext context) {
    return const Header();
  }
}
