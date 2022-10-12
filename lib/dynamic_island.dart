import 'package:android_window/android_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';

import 'generated/l10n.dart';
import 'modules/setting/setting_page.dart';
import 'speed_share.dart';

class DynamicIsland extends StatefulWidget {
  const DynamicIsland({Key key}) : super(key: key);

  @override
  State<DynamicIsland> createState() => _DynamicIslandState();
}

class _DynamicIslandState extends State<DynamicIsland>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Animation<double> radius;
  double maxHeight = 160;
  Widget content = const DynamicIslandSetting();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 600,
      ),
    );
    animation = CurvedAnimation(
      curve: const Interval(
        0.1,
        1.0,
        curve: Curves.easeInOut,
      ),
      parent: controller,
    );
    radius = CurvedAnimation(
      curve: const Interval(
        0.0,
        0.1,
        curve: Curves.easeInOut,
      ),
      parent: controller,
    );
    controller.addListener(() {
      setState(() {});
    });
    if (!pop) {
    } else {
      AndroidWindow.setHandler((name, data) async {
        switch (name) {
          case 'clipboard':
            content = Center(
              child: Text(
                data,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
            maxHeight = 40;
            anim();
            Future.delayed(const Duration(milliseconds: 1200), () {
              anim();
            });
            break;
          case 'file_receive':
            ChatController chatController = Get.put(ChatController());
            Get.put(DownloadController());
            chatController.onNewFileReceive = (file) {
              content = file;
              maxHeight = 90;
              anim();
            };
            Log.e('>>>>:$data');
            chatController.handleMessage(Map<String, dynamic>.from(data));
        }
        return null;
      });
      // anim();
    }

    // controller.addListener(() {
    //   setState(() {

    //   });
    // });
  }

  Widget pre;

  Future<void> anim() async {
    // await Future.delayed(Duration(seconds: 1));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    if (controller.isCompleted) {
      await controller.reverse();
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
      if (pop) {
        // Navigator.pop(context);
        AndroidWindow.close();
      }
      if (pre != null) {
        content = pre;
      }
    } else {
      await controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        anim();
        return false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          // double value = details.delta.dy / 300;
          controller.value += details.delta.dy / 160;
          Log.d(details.delta.dy);
        },
        onPanEnd: ((details) async {
          if (controller.value >= 0.8) {
            await controller.forward();
          } else {
            await controller.reverse();
            SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: [SystemUiOverlay.top],
            );
            if (pop) {
              // Navigator.pop(context);
              AndroidWindow.close();
            }
            if (pre != null) {
              content = pre;
            }
          }
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                anim();
              },
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 24 * radius.value + (animation.value * 300),
                      height: 24 * radius.value + (animation.value * maxHeight),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(
                          12 + (animation.value * 20),
                        ),
                      ),
                      padding: EdgeInsets.all(12.w),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..scale(0.4 + 0.6 * animation.value),
                        alignment: Alignment.topCenter,
                        child: content,
                      ),
                    ),
                  );
                },
                child: Container(),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                maxHeight = 160;
                pre = content;
                content = const DynamicIslandSetting();
                await anim();
              },
              onDoubleTap: () async {
                maxHeight = 160;
                pre = content;
                content = const DynamicIslandSetting();
                await anim();
              },
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  );
                },
                child: Container(),
              ),
            ),
            if (!controller.isDismissed)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    anim();
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class DynamicIslandSetting extends StatefulWidget {
  const DynamicIslandSetting({Key key}) : super(key: key);

  @override
  State<DynamicIslandSetting> createState() => _DynamicIslandSettingState();
}

class _DynamicIslandSettingState extends State<DynamicIslandSetting> {
  SettingController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: GetBuilder<SettingController>(builder: (context) {
        return Column(
          children: [
            SettingItem(
              onTap: () {
                controller.enableAutoChange(!controller.enableAutoDownload);
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: 290,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.autoDownload,
                        style: TextStyle(
                          fontSize: 18.w,
                          color: Colors.white,
                        ),
                      ),
                      AquaSwitch(
                        value: controller.enableAutoDownload,
                        onChanged: controller.enableAutoChange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SettingItem(
              onTap: () {
                controller.clipChange(!controller.clipboardShare);
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: 290,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.clipboardshare,
                        style: TextStyle(
                          fontSize: 18.w,
                          color: Colors.white,
                        ),
                      ),
                      AquaSwitch(
                        value: controller.clipboardShare,
                        onChanged: controller.clipChange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SettingItem(
              onTap: () {
                controller.vibrateChange(!controller.vibrate);
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: 290,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.messageNote,
                        style: TextStyle(
                          fontSize: 18.w,
                          color: Colors.white,
                        ),
                      ),
                      AquaSwitch(
                        value: controller.vibrate,
                        onChanged: controller.vibrateChange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
