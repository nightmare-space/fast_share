import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide ScreenType;
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/device_controller.dart';
import 'package:speed_share/app/controller/file_controller.dart';
import 'package:speed_share/pages/online_list.dart';
import 'package:speed_share/routes/page_route_builder.dart';
import 'package:speed_share/utils/scan_util.dart';
import 'package:speed_share/v2/desktop_drawer.dart';
import 'package:speed_share/v2/file_page.dart';
import 'package:speed_share/v2/send_file_bottom_sheet.dart';

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
    chatController.createChatRoom();
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
                        HomePage(),
                        ShareChatV2(),
                        FilePage(),
                        HomePage(),
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
    return Column(
      children: [
        Expanded(
          child: [
            HomePage(),
            FilePage(),
            HomePage(),
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
  int index = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: OverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xfff7f7f7),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildHead(context),
                          SizedBox(height: 12.w),
                          OnlineList(),
                          SizedBox(height: 4.w),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                width: 101.96,
                                height: 160.w,
                                padding: EdgeInsets.all(10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '记事本',
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
                                      width: 100,
                                    ),
                                    SizedBox(
                                      height: 10.w,
                                    ),
                                    Text(
                                      '此记事本模块的内容。',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    'http://nightmare.fun/YanTool/image/hong.jpg',
                                    height: 160.w,
                                    fit: BoxFit.fitWidth,
                                    // width: double.infinity,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 126,
                            padding: EdgeInsets.all(10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '近期文件',
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
                                  color:
                                      const Color(0xffE0C4C4).withOpacity(0.2),
                                  height: 1,
                                ),
                                SizedBox(
                                  height: 4.w,
                                ),
                                Expanded(
                                  child: GetBuilder<FileController>(
                                    builder: (ctl) {
                                      List<Widget> children = [];
                                      for (FileSystemEntity name
                                          in ctl.getRecent()) {
                                        children.add(
                                          SizedBox(
                                            width: 40.w,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                getIconByExt(name.path),
                                                SizedBox(height: 4.w),
                                                SizedBox(
                                                  height: 14.w,
                                                  child: Text(
                                                    basename(name.path),
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontSize: 6.w,
                                                      height: 1,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                        children.add(
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                        );
                                      }
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: children,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.put(ChatController());
                              Get.to(const ShareChatV2());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 126,
                              padding: EdgeInsets.all(10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '全部设备',
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
                                    '当前没有任何消息，点击查看连接二维码',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
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

  Widget buildHead(BuildContext context) {
    return const Header();
  }
}
