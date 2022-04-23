import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/global/widget/pop_button.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:speed_share/v2/header.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widget/xliv-switch.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SettingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    TextStyle title = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 16.w,
    );
    return Scaffold(
      body: SafeArea(
        left: false,
        child: GetBuilder<SettingController>(builder: (_) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Header(),
                ),
                // if (ResponsiveWrapper.of(context).isMobile)
                //   SizedBox(
                //     height: 40.w,
                //     child: Row(
                //       children: [
                //         ResponsiveWrapper.of(context).isMobile
                //             ? const PopButton()
                //             : SizedBox(width: 12.w),
                //         Text(
                //           '设置',
                //           style: Theme.of(context).textTheme.bodyText2.copyWith(
                //                 fontWeight: bold,
                //                 fontSize: 18.w,
                //               ),
                //         ),
                //       ],
                //     ),
                //   ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.w),
                  child: Text(
                    '常规',
                    style: title,
                  ),
                ),
                SettingItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '下载路径',
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      Text(
                        _.savePath,
                        style: TextStyle(
                          fontSize: 16.w,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .color
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  onTap: () {
                    controller.enableAutoChange(!controller.enableAutoDownload);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '自动下载',
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      AquaSwitch(
                        value: controller.enableAutoDownload,
                        onChanged: controller.enableAutoChange,
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  onTap: () {
                    controller.clipChange(!controller.clipboardShare);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '剪切板共享',
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      AquaSwitch(
                        value: controller.clipboardShare,
                        onChanged: controller.clipChange,
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  onTap: () {
                    controller.vibrateChange(!controller.vibrate);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '收到消息时振动提醒',
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      AquaSwitch(
                        value: controller.vibrate,
                        onChanged: controller.vibrateChange,
                      ),
                    ],
                  ),
                ),
                // Text('隐私和安全'),
                // Text('消息和通知'),
                // Text('快捷键'),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.w),
                  child: Text(
                    '关于速享',
                    style: title,
                  ),
                ),
                SettingItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '当前版本',
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      Text(
                        'v2.0',
                        style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .color
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  onTap: () async {
                    String url =
                        'https://github.com/nightmare-space/speed_share';
                    await canLaunch(url)
                        ? await launch(url)
                        : throw 'Could not launch $url';
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '开源地址',
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  onTap: () async {
                    String url =
                        'http://nightmare.fun/YanTool/resources/SpeedShare/?C=N;O=A';
                    await canLaunch(url)
                        ? await launch(url)
                        : throw 'Could not launch $url';
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '其他版本下载',
                            style: TextStyle(
                              fontSize: 18.w,
                            ),
                          ),
                          Text(
                            '速享还支持Windows、macOS、Linux',
                            style: TextStyle(
                              fontSize: 14.w,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .color
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '开发者',
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      Text(
                        '梦魇兽',
                        style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .color
                              .withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'UI设计师',
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      Text(
                        '柚凛',
                        style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .color
                              .withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  const SettingItem({
    Key key,
    this.child,
    this.onTap,
  }) : super(key: key);
  final Widget child;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: SizedBox(
          height: 56.w,
          child: Align(
            alignment: Alignment.centerLeft,
            child: child,
          ),
        ),
      ),
    );
  }
}

class AquaSwitch extends StatelessWidget {
  final bool value;

  final ValueChanged<bool> onChanged;

  final Color activeColor;

  final Color unActiveColor;

  final Color thumbColor;

  const AquaSwitch({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.activeColor,
    this.unActiveColor,
    this.thumbColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.78,
      child: XlivSwitch(
        unActiveColor: unActiveColor ?? Theme.of(context).colorScheme.surface4,
        activeColor: Theme.of(context).primaryColor ?? activeColor,
        thumbColor: thumbColor,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
