import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/utils/scan_util.dart';
import 'package:speed_share/v2/file_page.dart';

import 'header.dart';
import 'share_chat_window.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: OverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xfff7f7f7),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                Expanded(
                  child: [
                    Column(
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
                                color: const Color(0xffE0C4C4).withOpacity(0.2),
                                height: 1,
                              ),
                              SizedBox(
                                height: 10.w,
                              ),
                              Text(
                                '此记事本模块的内容，在有设备在进行连接后，会自动同步最新内容。',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
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
                            Get.to(ShareChatV2());
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
                                  color:
                                      const Color(0xffE0C4C4).withOpacity(0.2),
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
                                '我的电脑',
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
                                color: const Color(0xffE0C4C4).withOpacity(0.2),
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
                      ],
                    ),
                    FilePage(),
                  ][index],
                ),
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
                          size: 18.w,
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          '首页',
                          style: TextStyle(
                            fontSize: 12.w,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ],
                    ),
                    Stack(
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.file_copy,
                          size: 18.w,
                        ),
                        SizedBox(height: 4.w),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHead(BuildContext context) {
    return Header();
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
        height: 60.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
