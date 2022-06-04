import 'dart:math';
import 'dart:ui';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/device_controller.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/global/widgets/pop_button.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:file_manager_view/file_manager_view.dart' as fm;

// 聊天窗口
class ShareChatV2 extends StatefulWidget {
  const ShareChatV2({
    Key key,
    this.chatServerAddress,
  }) : super(key: key);

  final String chatServerAddress;
  @override
  State createState() => _ShareChatV2State();
}

class _ShareChatV2State extends State<ShareChatV2>
    with SingleTickerProviderStateMixin {
  ChatController controller = Get.find();
  AnimationController menuAnim;
  bool dropping = false;
  int index = 0;
  // 输入框控制器
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    menuAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    controller.initChat(
      widget.chatServerAddress,
    );
    // if (GetPlatform.isDesktop && !GetPlatform.isWeb) {
    //   windowManager.setSize(SizeConfig.chatSize);
    // }
  }

  @override
  void dispose() {
    menuAnim.dispose();
    // if (GetPlatform.isDesktop && !GetPlatform.isWeb) {
    //   windowManager.setSize(SizeConfig.defaultSize);
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: OverlayStyle.dark,
      child: DropTarget(
        onDragDone: (detail) async {
          Log.d('files -> ${detail.files}');
          setState(() {});
          if (detail.files.isNotEmpty) {
            controller.sendXFiles(detail.files);
          }
        },
        onDragUpdated: (details) {
          setState(() {
            // offset = details.localPosition;
          });
        },
        onDragEntered: (detail) {
          setState(() {
            dropping = true;
            // offset = detail.localPosition;
          });
        },
        onDragExited: (detail) {
          setState(() {
            dropping = false;
            // offset = null;
          });
        },
        child: Stack(
          children: [
            body(context),
            if (dropping)
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4.0,
                  sigmaY: 4.0,
                ),
                child: Material(
                  child: Center(
                    child: Text(
                      '释放以分享文件到共享窗口~',
                      style: TextStyle(
                        color: AppColors.fontColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.w,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Scaffold body(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        left: false,
        child: Stack(
          alignment: Alignment.center,
          // fit: StackFit.passthrough,
          children: [
            Column(
              children: [
                if (ResponsiveWrapper.of(context).isMobile)
                  appbar(context)
                else
                  SizedBox(height: 10.w),
                Expanded(
                  child: Row(
                    children: [
                      if (ResponsiveWrapper.of(context).isMobile) leftNav(),
                      chatBody(context),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded chatBody(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w),
        child: Column(
          children: [
            Expanded(child: chatList(context)),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.white,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 64.w,
                    maxHeight: 240.w,
                  ),
                  child: sendMsgContainer(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector chatList(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.focusNode.unfocus();
      },
      child: Material(
        borderRadius: BorderRadius.circular(10.w),
        color: Theme.of(context).backgroundColor,
        clipBehavior: Clip.antiAlias,
        child: GetBuilder<ChatController>(builder: (context) {
          List<Widget> children = [];
          if (controller.backup.isNotEmpty) {
            children = controller.backup;
          } else {
            children = controller.children;
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              0.w,
              0.w,
              0.w,
              80.w,
            ),
            controller: controller.scrollController,
            itemCount: children.length,
            cacheExtent: 99999,
            itemBuilder: (c, i) {
              return (children)[i];
            },
          );
        }),
      ),
    );
  }

  SizedBox leftNav() {
    return SizedBox(
      width: 64.w,
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 4.w),
            LeftNav(
              value: index,
            ),
          ],
        ),
      ),
    );
  }

  Material appbar(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SizedBox(
        height: 48.w,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (ResponsiveWrapper.of(context).isMobile) const PopButton(),
            SizedBox(width: 12.w),
            Text(
              '全部设备',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: AppColors.fontColor,
                    fontWeight: bold,
                    fontSize: 16.w,
                  ),
            ),
            SizedBox(width: 4.w),
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
          ],
        ),
        // child: AppBar(
        //   systemOverlayStyle: OverlayStyle.dark,
        //   centerTitle: false,
        //   title: Text(
        //     '全部设备',
        //     style: Theme.of(context).textTheme.bodyText2.copyWith(
        //           color: AppColors.fontColor,
        //           fontWeight: bold,
        //           fontSize: 16.w,
        //         ),
        //   ),
        //   leading: const PopButton(),
        //   actions: [
        //     NiIconButton(
        //       onTap: () {
        //         Get.dialog(ShowQRPage(
        //           port: controller.chatBindPort,
        //         ));
        //       },
        //       child: Image.asset('assets/icon/qr.png'),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Widget menu() {
    return AnimatedBuilder(
      animation: menuAnim,
      builder: (c, child) {
        return SizedBox(
          height: 100.w * menuAnim.value,
          child: child,
        );
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16.w),
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            SizedBox(
              width: 80.w,
              height: 80.w,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.w),
                onTap: () {
                  menuAnim.reverse();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (GetPlatform.isDesktop || GetPlatform.isWeb) {
                      controller.sendFileForBroswerAndDesktop();
                    } else if (GetPlatform.isAndroid) {
                      controller.sendFileForAndroid(
                        useSystemPicker: true,
                      );
                    }
                  });
                },
                child: Tooltip(
                  message: '点击将会调用系统的文件选择器',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: 36.w,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        '系统管理器',
                        style: TextStyle(
                          color: AppColors.fontColor,
                          fontWeight: bold,
                          fontSize: 12.w,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (GetPlatform.isAndroid && !GetPlatform.isWeb)
              Theme(
                data: Theme.of(context),
                child: Builder(builder: (context) {
                  return SizedBox(
                    width: 80.w,
                    height: 80.w,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.w),
                      onTap: () {
                        menuAnim.reverse();
                        Future.delayed(const Duration(milliseconds: 100), () {
                          controller.sendFileForAndroid(
                            context: context,
                          );
                        });
                      },
                      child: Tooltip(
                        message: '点击将调用自实现的文件选择器',
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.file_copy,
                              size: 36.w,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(height: 4.w),
                            Text(
                              '内部管理器',
                              style: TextStyle(
                                color: AppColors.fontColor,
                                fontWeight: bold,
                                fontSize: 12.w,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            if (!GetPlatform.isWeb)
              SizedBox(
                width: 80.w,
                height: 80.w,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.w),
                  onTap: () async {
                    menuAnim.reverse();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      controller.sendDir();
                    });
                  },
                  child: Tooltip(
                    message: '点击将调用自实现的文件夹选择器',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          '${fm.Config.packagePrefix}assets/icon/dir.svg',
                          width: 36.w,
                          height: 36.w,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          '文件夹',
                          style: TextStyle(
                            color: AppColors.fontColor,
                            fontWeight: bold,
                            fontSize: 12.w,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget sendMsgContainer(BuildContext context) {
    return GetBuilder<ChatController>(builder: (ctl) {
      return Material(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.w),
          topRight: Radius.circular(12.w),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.w, 8.w, 8.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      width: double.infinity,
                      // height: 40.w,
                      child: Center(
                        child: TextField(
                          focusNode: controller.focusNode,
                          controller: controller.controller,
                          autofocus: false,
                          maxLines: 8,
                          minLines: 1,
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).backgroundColor,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: GetPlatform.isWeb ? 16.w : 10.w,
                              horizontal: 12.w,
                            ),
                          ),
                          style: const TextStyle(
                            textBaseline: TextBaseline.ideographic,
                          ),
                          onSubmitted: (_) {
                            controller.sendTextMsg();
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              controller.focusNode.requestFocus();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureWithScale(
                    onTap: () {
                      if (controller.hasInput) {
                        controller.sendTextMsg();
                      } else {
                        if (menuAnim.isCompleted) {
                          menuAnim.reverse();
                        } else {
                          menuAnim.forward();
                        }
                      }
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(24.w),
                      // borderOnForeground: true,
                      color: Theme.of(context).backgroundColor,
                      child: SizedBox(
                        width: 46.w,
                        height: 46.w,
                        child: AnimatedBuilder(
                          animation: menuAnim,
                          builder: (c, child) {
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..rotateZ(menuAnim.value * pi / 4),
                              child: child,
                            );
                          },
                          child: Icon(
                            controller.hasInput ? Icons.send : Icons.add,
                            size: 20.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                ],
              ),
              SizedBox(height: 4.w),
              menu(),
            ],
          ),
        ),
      );
    });
  }
}

class LeftNav extends StatefulWidget {
  const LeftNav({
    Key key,
    this.value,
  }) : super(key: key);
  final int value;

  @override
  State<LeftNav> createState() => _LeftNavState();
}

class _LeftNavState extends State<LeftNav> with SingleTickerProviderStateMixin {
  DeviceController deviceController = Get.find();
  ChatController chatController = Get.find();
  AnimationController controller;
  Animation offset;
  int index;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
    );
    offset = Tween<double>(begin: 0, end: 0).animate(controller);
    index = widget.value;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String getIcon(int type) {
    switch (type) {
      case 0:
        return 'assets/icon/phone.png';
        break;
      case 1:
        return 'assets/icon/computer.png';
        break;
      case 2:
        return 'assets/icon/broswer.png';
        break;
      default:
        return 'assets/icon/computer.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: controller,
                builder: (context, c) {
                  return SizedBox(
                    height: offset.value,
                  );
                },
              ),
              Stack(
                children: [
                  Material(
                    color: Theme.of(context).backgroundColor,
                    child: SizedBox(
                      height: 10.w,
                      width: 64.w,
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12.w),
                    ),
                    child: SizedBox(
                      height: 10.w,
                      width: 64.w,
                    ),
                  ),
                ],
              ),
              Container(
                height: 48.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.w),
                    bottomLeft: Radius.circular(12.w),
                  ),
                ),
              ),
              Stack(
                children: [
                  Material(
                    color: Theme.of(context).backgroundColor,
                    child: SizedBox(
                      height: 10.w,
                      width: 60.w,
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.w),
                    ),
                    child: SizedBox(
                      height: 10.w,
                      width: 60.w,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 10.w,
            ),
            MenuButton(
              value: 0,
              enable: index == 0,
              child: Image.asset(
                'assets/icon/all.png',
                width: 24.w,
                height: 24.w,
                package: Config.package,
              ),
              onChange: (value) {
                index = value;
                offset = Tween<double>(begin: offset.value, end: 0.w)
                    .animate(controller);
                chatController.restoreList();
                controller.reset();
                controller.forward();
                setState(() {});
              },
            ),
            GetBuilder<DeviceController>(builder: (_) {
              return Column(
                children: [
                  for (int i = 0;
                      i < deviceController.connectDevice.length;
                      i++)
                    MenuButton(
                      value: i + 1,
                      enable: index == i + 1,
                      child: Image.asset(
                        getIcon(deviceController.connectDevice[i].deviceType),
                        width: 32.w,
                        height: 32.w,
                        package: Config.package,
                      ),
                      onChange: (value) {
                        index = value;
                        offset = Tween<double>(
                          begin: offset.value,
                          end: (i + 1) * 60.w,
                        ).animate(controller);
                        controller.reset();
                        controller.forward();
                        chatController.changeListToDevice(
                          deviceController.connectDevice[i],
                        );
                        setState(() {});
                      },
                    ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key key,
    this.enable = true,
    this.value,
    this.onChange,
    this.child,
  }) : super(key: key);
  final bool enable;
  final int value;
  final void Function(int index) onChange;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onChange?.call(value);
          },
          child: SizedBox(
            width: 60.w,
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.w,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.w),
                  bottomLeft: Radius.circular(10.w),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      width: 48.w,
                      height: 48.w,
                      child: Center(
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 12.w,
        ),
      ],
    );
  }
}
