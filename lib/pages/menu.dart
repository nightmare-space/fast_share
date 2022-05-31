import 'dart:math';

import 'package:file_manager_view/core/io/interface/file_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:logger_view/logger_view.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/pages/dialog/join_chat.dart';
import 'package:speed_share/utils/scan_util.dart';

import 'show_qr_page.dart';

class HeaderMenu extends StatefulWidget {
  const HeaderMenu({
    Key key,
    this.entity,
    this.offset = const Offset(0, 0),
  }) : super(key: key);
  final FileEntity entity;
  final Offset offset;

  @override
  State<HeaderMenu> createState() => _HeaderMenuState();
}

class _HeaderMenuState extends State<HeaderMenu> {
  ChatController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          top: min(
            widget.offset.dy,
            MediaQuery.of(context).size.height - 260.w,
          ),
          left: min(
            widget.offset.dx,
            MediaQuery.of(context).size.width - 170.w,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 160.w,
              child: Material(
                borderRadius: BorderRadius.circular(12.w),
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          Get.dialog(const JoinChat());
                        },
                        child: SizedBox(
                          height: 48.w,
                          child: Align(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 24.w,
                                  ),
                                  SizedBox(width: 12.w),
                                  const Text(
                                    '输入连接',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          ScanUtil.parseScan();
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                          height: 48.w,
                          child: Align(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    GlobalAssets.qrCode,
                                    color: Colors.black,
                                    width: 24.w,
                                  ),
                                  SizedBox(width: 12.w),
                                  const Text(
                                    '扫码',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          Get.dialog(ShowQRPage(
                            port: controller.chatBindPort,
                          ));
                        },
                        child: SizedBox(
                          height: 48.w,
                          child: Align(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/icon/qr.png',
                                    width: 20.w,
                                  ),
                                  SizedBox(width: 12.w),
                                  const Text(
                                    '二维码',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          Get.to(
                            () => Responsive(
                              builder: (context, screenType) {
                                return const Material(
                                  child: SafeArea(
                                    child: LoggerView(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 48.w,
                          child: Align(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: Colors.black,
                                    size: 24.w,
                                  ),
                                  SizedBox(width: 12.w),
                                  const Text(
                                    '日志',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
