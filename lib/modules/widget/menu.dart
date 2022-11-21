import 'dart:io';
import 'dart:math';

import 'package:file_manager_view/core/io/interface/file_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:logger_view/logger_view.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/generated/l10n.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/utils/scan_util.dart';

import '../dialog/join_chat.dart';

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
            MediaQuery.of(context).size.width - 190.w,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 180.w,
              child: Material(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(12.w),
                child: Material(
                  borderRadius: BorderRadius.circular(12.w),
                  clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).surface1,
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
                                      color: Theme.of(context).colorScheme.onBackground,
                                      size: 24.w,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      S.of(context).inputConnect,
                                      style: const TextStyle(
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
                                      color: Theme.of(context).colorScheme.onBackground,
                                      width: 24.w,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      S.of(context).scan,
                                      style: const TextStyle(
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
                                  return const LoggerView();
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
                                      color: Theme.of(context).colorScheme.onBackground,
                                      size: 24.w,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      S.of(context).log,
                                      style: const TextStyle(
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
                            // Navigator.of(context).pop();
                            SettingController settingController = Get.find();
                            final dir = settingController.savePath;
                            const String fileName = 'log.txt';
                            File newFile = File('${dir}_$fileName');
                            if (newFile.existsSync()) {
                              newFile.deleteSync();
                            }

                            StringBuffer sb = StringBuffer();
                            for (var log in Log.buffer) {
                              sb.writeln('[${twoDigits(log.time.hour)}:${twoDigits(log.time.minute)}:${twoDigits(log.time.second)}] ${log.data}');
                            }
                            newFile.writeAsString(sb.toString());
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
                                      Icons.download,
                                      color: Theme.of(context).colorScheme.onBackground,
                                      size: 24.w,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      '输出 ${S.of(context).log}',
                                      style: const TextStyle(
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
        ),
      ],
    );
  }
}
