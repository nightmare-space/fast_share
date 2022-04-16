import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide ScreenType;
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/device_controller.dart';
import 'package:speed_share/app/controller/file_controller.dart';
import 'package:speed_share/pages/online_list.dart';
import 'package:speed_share/v2/desktop_drawer.dart';
import 'package:speed_share/v2/file_page.dart';
import 'package:speed_share/v2/preview_image.dart';

import 'header.dart';
import 'icon.dart';
import 'nav.dart';
import 'share_chat_window.dart';

// 响应式布局
class AdaptiveEntryPoint extends StatefulWidget {
  const AdaptiveEntryPoint({Key key}) : super(key: key);

  @override
  State<AdaptiveEntryPoint> createState() => _AdaptiveEntryPointState();
}

class _AdaptiveEntryPointState extends State<AdaptiveEntryPoint> {
  ChatController chatController = Get.put(ChatController());
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
    ScreenType screenType = Responsive.of(context).screenType;
    if (screenType == ScreenType.desktop || screenType == ScreenType.tablet) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 2.w,
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
                    Expanded(
                      child: [
                        const HomePage(),
                        const ShareChatV2(),
                        const FilePage(),
                        const HomePage(),
                      ][page],
                    ),
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
            child: [
              const HomePage(),
              const FilePage(),
              const HomePage(),
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
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChatController chatController = Get.put(ChatController());
  FileController fileController = Get.find();
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  CardWrapper onknownFile(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '最近文件',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 16.w,
            ),
          ),
          SizedBox(
            height: 8.w,
          ),
          Container(
            color: const Color(0xffE0C4C4).withOpacity(0.2),
            height: 1,
          ),
          SizedBox(
            height: 4.w,
          ),
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: OverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          buildHead(context),
                          SizedBox(height: 12.w),
                          const OnlineList(),
                          SizedBox(height: 4.w),
                          Row(
                            children: [
                              Expanded(
                                child: GetBuilder<FileController>(
                                    builder: (context) {
                                  File file = fileController.getRecentImage();
                                  if (file == null) {
                                    return const SizedBox();
                                  }
                                  return GestureWithScale(
                                    onTap: () {
                                      Get.to(PreviewImage(
                                        path: file.path,
                                      ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(file),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.w,
                                  ),
                                  Container(
                                    color: const Color(0xffE0C4C4)
                                        .withOpacity(0.2),
                                    height: 1,
                                  ),
                                  SizedBox(
                                    height: 10.w,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    height: 100.w,
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8.w),
                                    child: SelectableText(
                                      'http://127.0.0.1:20000/file',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          SizedBox(height: 10.w),
                          GetBuilder<DeviceController>(builder: (_) {
                            List<Widget> children = [];
                            DeviceController deviceController = Get.find();
                            for (Device device
                                in deviceController.connectDevice) {
                              children.add(
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  height: 126,
                                  padding: EdgeInsets.all(10.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        device.id.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4.w,
                                      ),
                                      Container(
                                        color: const Color(0xffE0C4C4)
                                            .withOpacity(0.2),
                                        height: 1,
                                      ),
                                      SizedBox(
                                        height: 10.w,
                                      ),
                                      Text(
                                        '如果有新的设备链接，会在下方添加新的设备版块，在首页手指向上滑动，可以拖动。',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              children.add(SizedBox(
                                height: 8.w,
                              ));
                            }
                            return Column(
                              children: children,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const FilePage(),
                ][index],
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector allDevice(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.put(ChatController());
        Get.to(const ShareChatV2());
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
                '全部设备',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              SizedBox(
                height: 4.w,
              ),
              Container(
                color: const Color(0xffE0C4C4).withOpacity(0.2),
                height: 1,
              ),
              SizedBox(
                height: 10.w,
              ),
              chatController.children.isEmpty
                  ? Text(
                      '当前没有任何消息，点击查看连接二维码',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 100.w,
                      child: ListView.builder(
                        itemCount: chatController.children.length,
                        itemBuilder: (c, i) {
                          return chatController.children[i];
                        },
                      ),
                    ),
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
