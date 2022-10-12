import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/modules/dialog/show_qr_page.dart';

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
                      width: 4.w,
                      height: 16.w,
                      decoration: BoxDecoration(
                        color: value ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(16.w),
                      ),
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
              NiIconButton(
                onTap: () {
                  Get.dialog(ShowQRPage(
                    port: controller.messageBindPort,
                  ));
                },
                child: Image.asset(
                  'assets/icon/qr.png',
                  width: 20.w,
                  package: Config.package,
                ),
              ),
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
  Timer timer;
  int page = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      page += 1;
      page = page % 2;
      if (page == 1) {
        DeviceController deviceController = Get.find();
        if (deviceController.connectDevice.isEmpty) {
          page = 0;
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            fillColor: Colors.transparent,
            child: child,
          );
        },
        duration: const Duration(milliseconds: 600),
        child: [
          Align(
            alignment: Alignment.centerLeft,
            child: GetBuilder<DeviceController>(builder: (_) {
              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '当前有',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '${deviceController.connectDevice.length}',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '个设备会收到消息',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          Row(
            children: [
              GetBuilder<DeviceController>(
                builder: (controller) {
                  List<Widget> children = [];
                  for (Device device in controller.connectDevice) {
                    children.add(
                      Material(
                        color: device.deviceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.w),
                        child: SizedBox(
                          height: 32.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Center(
                              child: Text(device.deviceName),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    child: Row(
                      children: children,
                    ),
                  );
                },
              ),
            ],
          ),
        ][page],
      ),
    );
  }
}
