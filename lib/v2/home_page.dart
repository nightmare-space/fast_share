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
import 'package:speed_share/routes/page_route_builder.dart';
import 'package:speed_share/utils/scan_util.dart';
import 'package:speed_share/v2/desktop_drawer.dart';
import 'package:speed_share/v2/file_page.dart';
import 'package:speed_share/v2/send_file_bottom_sheet.dart';

import 'header.dart';
import 'icon.dart';
import 'share_chat_window.dart';

// 响应式布局
class AdaptiveEntryPoint extends StatefulWidget {
  const AdaptiveEntryPoint({Key key}) : super(key: key);

  @override
  State<AdaptiveEntryPoint> createState() => _AdaptiveEntryPointState();
}

class _AdaptiveEntryPointState extends State<AdaptiveEntryPoint> {
  @override
  Widget build(BuildContext context) {
    ScreenType screenType = Responsive.of(context).screenType;
    if (screenType == ScreenType.desktop || screenType == ScreenType.tablet) {
      return Row(
        children: [
          DesktopDrawer(),
          Expanded(child: HomePage()),
        ],
      );
    }
    return HomePage();
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
                          SizedBox(
                            height: 12.w,
                          ),
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
                                  height: 10.w,
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
                          Builder(builder: (context) {
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
                                        device.id,
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
              Stack(
                alignment: Alignment.center,
                children: [
                  BottomTab(
                    onChange: (value) {
                      index = min(value, 1);
                      setState(() {});
                    },
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            size: 14.w,
                          ),
                          SizedBox(height: 2.w),
                          Text(
                            '首页',
                            style: TextStyle(
                              fontSize: 12.w,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_copy,
                            size: 14.w,
                          ),
                          SizedBox(height: 2.w),
                          Text(
                            '文件',
                            style: TextStyle(
                              fontSize: 12.w,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureWithScale(
                    onTap: () {
                      Navigator.of(context).push(CustomRoute(
                        const SendFilePage(),
                      ));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xff6A6DED),
                          ),
                          transformAlignment: Alignment.center,
                          transform: Matrix4.identity()..rotateZ(pi / 4),
                          width: 42.w,
                          height: 42.w,
                        ),
                        Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

class BottomTab extends StatefulWidget {
  const BottomTab({Key key, this.children, this.onChange}) : super(key: key);
  final List<Widget> children;
  final void Function(int index) onChange;

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SizedBox(
        height: 58.w,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < widget.children.length; i++)
              IconButton(
                padding: EdgeInsets.all(4.w),
                onPressed: () {
                  widget.onChange?.call(i);
                },
                icon: widget.children[i],
              ),
          ],
        ),
      ),
    );
  }
}
