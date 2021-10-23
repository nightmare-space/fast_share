import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/routes/app_pages.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/utils/scan_util.dart';
import 'package:speed_share/widgets/circle_animation.dart';
import 'package:supercharged/supercharged.dart';
import 'dialog/join_chat.dart';
import 'setting_page.dart';

/// Create by Nightmare at 2021
/// 速享的主页
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool serverOpend = true;
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
  // 处理其他设备的分享
  Future<void> handleSendFile() async {
    if (GetPlatform.isAndroid) {
      MethodChannel channel = MethodChannel('send_channel');
      channel.setMethodCallHandler((call) async {
        if (call.method == 'send_file') {
          // File file = File.fromUri(Uri.parse(call.arguments));
          // print(file.path);
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
          controller.sendFileFromPath(Uri.decodeFull(realPath));
        }
      });
    }
  }

  double size = 100;

  @override
  Widget build(BuildContext context) {
    AppBar appBar;
    // if (GetPlatform.isAndroid) {
    appBar = AppBar(
      actions: [
        if (GetPlatform.isAndroid)
          NiIconButton(
            child: SvgPicture.asset(
              GlobalAssets.qrCode,
              color: Colors.black,
            ),
            onTap: () async {
              ScanUtil.parseScan();
            },
          ),
        NiIconButton(
          child: Icon(
            Icons.settings,
            color: Colors.black,
            size: 24.w,
          ),
          onTap: () async {
            Get.to(SettingPage());
          },
        ),
        SizedBox(width: Dimens.gap_dp12),
      ],
    );
    return Scaffold(
      // appBar: ,
      resizeToAvoidBottomInset: false,
      body: Stack(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          appBar,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  // padding: const EdgeInsets.only(top: 200.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WaterRipple(),
                      SizedBox(
                        width: size,
                        height: size,
                        child: Padding(
                          padding: EdgeInsets.all(64.0 * size / 1024),
                          child: Builder(
                            builder: (_) {
                              double _size = size - 32.0 * size / 1024;
                              double padding = 16.0 * _size / 160;
                              return Material(
                                borderRadius:
                                    BorderRadius.circular(32 * _size / 160),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                    // color: Colors.red,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.indigoAccent,
                                        Color(0xffedbac8),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: padding,
                                      horizontal: padding,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        LayoutBuilder(builder: (_, c) {
                                          return Stack(
                                            children: [
                                              // SvgPicture.asset(
                                              //   'assets/icon/copy.svg',
                                              //   // color: Colors.black12,
                                              //   height: c.maxHeight,
                                              // ),
                                              Icon(
                                                Icons.share,
                                                size: c.maxHeight,
                                                color: Color(0xfff5f5f7),
                                              ),
                                              // SvgPicture.asset(
                                              //   'assets/icon/rom.svg',
                                              //   height: c.maxHeight,
                                              // ),
                                              // YSpaceLogoWidget()
                                            ],
                                          );
                                        }),
                                        // SvgPicture.asset(
                                        //   'assets/icon/terminal.svg',
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NiCardButton(
                        borderRadius: 24,
                        onTap: () {
                          Get.toNamed(
                            '${Routes.chat}?needCreateChatServer=true',
                          );
                        },
                        color: AppColors.accentColor,
                        child: SizedBox(
                          width: 150.w,
                          height: 200.w,
                          child: Center(
                            child: Text(
                              '发起共享',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      NiCardButton(
                        borderRadius: 24,
                        onTap: () {
                          Get.dialog(JoinChat());
                        },
                        color: AppColors.sendByUser,
                        child: SizedBox(
                          width: 150.w,
                          height: 200.w,
                          child: Center(
                            child: Text(
                              '加入共享',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatefulWidget {
  const LoginButton({
    Key key,
    this.onTap,
    this.title,
    this.backgroundColor,
    this.fontColor,
  }) : super(key: key);
  final Future<bool> Function() onTap;
  final String title;
  final Color backgroundColor;
  final Color fontColor;

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> with AnimationMixin {
  bool successExec = false;
  CustomAnimationControl tapControl = CustomAnimationControl.STOP;
  CustomAnimationControl execControl = CustomAnimationControl.STOP;
  final _tween = TimelineTween<String>()
    ..addScene(begin: 0.milliseconds, end: 300.milliseconds).animate(
      'width',
      tween: Dimens.setWidth(300).tweenTo(Dimens.setWidth(36)),
    )
    ..addScene(begin: 0.milliseconds, end: 300.milliseconds).animate(
      'radius',
      tween: Dimens.setWidth(8).tweenTo(Dimens.setWidth(18)),
    )
    ..addScene(begin: 0.milliseconds, end: 300.milliseconds).animate(
      'fontsize',
      tween: Dimens.font_sp14.tweenTo(Dimens.setWidth(0)),
    )
    ..addScene(begin: 300.milliseconds, end: 600.milliseconds).animate(
      'opacity',
      tween: 0.0.tweenTo(1.0),
    );
  // ..addScene(begin: 0.milliseconds, end: 3000.milliseconds).animate(
  //   "width",
  //   tween: 300.0.tweenTo(36.0),
  // );
  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      control: tapControl,
      tween: 0.0.tweenTo(1.0), // Pass in tween
      duration: const Duration(milliseconds: 200), // Obtain duration
      builder: (context, child, tapValue) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            tapControl = CustomAnimationControl.PLAY_REVERSE;
            execControl = CustomAnimationControl.PLAY;
            setState(() {});
            successExec = await widget.onTap();
            successExec = true;
            // if (!successExec) {
            execControl = CustomAnimationControl.PLAY_REVERSE;
            // }
            setState(() {});
            Feedback.forLongPress(context);
          },
          onTapDown: (_) {
            tapControl = CustomAnimationControl.PLAY;
            Feedback.forLongPress(context);
            setState(() {});
          },
          onTapCancel: () {
            tapControl = CustomAnimationControl.PLAY_REVERSE;
            Feedback.forLongPress(context);
            setState(() {});
          },
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(1.0 - tapValue * 0.05),
            child: CustomAnimation<TimelineValue<String>>(
              control: execControl,
              tween: _tween, // Pass in tween
              duration: _tween.duration, // Obtain duration
              builder: (context, child, value) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(value.get('radius')),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.04 - tapValue * 0.04,
                        ),
                        offset: const Offset(0.0, 0.0), //阴影xy轴偏移量
                        blurRadius: 0, //阴影模糊程度
                        spreadRadius: 0.0, //阴影扩散程度
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(value.get('radius')),
                    ),
                    child: SizedBox(
                      width: Dimens.setWidth(value.get('width')),
                      height: Dimens.setWidth(40),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                color: widget.fontColor,
                                fontWeight: FontWeight.bold,
                                fontSize: value.get('fontsize'),
                              ),
                            ),
                          ),
                          CustomAnimation<double>(
                            control: CustomAnimationControl.LOOP,
                            tween: 0.0.tweenTo(2 * pi), // Pass in tween
                            duration: const Duration(
                              milliseconds: 300,
                            ), // Obtain duration
                            builder: (context, child, rvalue) {
                              return Opacity(
                                opacity: value.get('opacity'),
                                child: Transform.rotate(
                                  angle: rvalue,
                                  child: Icon(
                                    Icons.refresh,
                                    size: Dimens.gap_dp30,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
