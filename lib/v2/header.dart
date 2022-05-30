import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';

import 'menu.dart';

// 主页显示的最上面那个header
class Header extends StatelessWidget {
  const Header({
    Key key,
    this.showAddress = true,
  }) : super(key: key);
  final bool showAddress;

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(width: 4.w),
              if (!GetPlatform.isWeb)
                ValueListenableBuilder<bool>(
                  valueListenable: controller.connectState,
                  builder: (_, value, __) {
                    return Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                          color: value ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(16.w)),
                    );
                  },
                ),
              SizedBox(width: 4.w),
              const HeaderSwiper(),
            ],
          ),
        ),
        Transform(
          transform: Matrix4.identity()..translate(4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 16.w),
              NiIconButton(
                onTap: () {
                  Get.dialog(HeaderMenu(
                    offset: Offset(MediaQuery.of(context).size.width, 40),
                  ));
                },
                child: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderSwiper extends StatefulWidget {
  const HeaderSwiper({Key key}) : super(key: key);

  @override
  State<HeaderSwiper> createState() => _HeaderSwiperState();
}

class _HeaderSwiperState extends State<HeaderSwiper> {
  ChatController controller = Get.find();
  DeviceController deviceController = Get.find();
  PageController pageController = PageController();
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      int next = (pageController.page + 1).toInt();
      pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 48.w,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: pageController,
          itemBuilder: (c, i) {
            if (i % 2 == 0) {
              return Align(
                alignment: Alignment.centerLeft,
                child: GetBuilder<DeviceController>(builder: (_) {
                  return Text(
                    '当前有${deviceController.connectDevice.length}个设备连接',
                    style: TextStyle(
                      fontSize: 16.w,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  );
                }),
              );
            }
            return Row(
              children: [
                Text(
                  '当前房间：',
                  style: TextStyle(
                    fontSize: 16.w,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                GetBuilder<ChatController>(builder: (_) {
                  return SizedBox(
                    height: 32.w,
                    child: Material(
                      borderRadius: BorderRadius.circular(8.w),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Center(
                          child: SelectableText(
                            controller.chatServerAddress,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                    ),
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
