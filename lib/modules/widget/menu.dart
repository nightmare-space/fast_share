import 'dart:io';
import 'dart:math';
import 'package:file_manager_view/core/io/interface/file_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/generated/l10n.dart';
import 'package:speed_share/themes/app_colors.dart';

import '../dialog/join_chat.dart';

class HeaderMenu extends StatefulWidget {
  const HeaderMenu({
    Key? key,
    this.entity,
    this.offset = const Offset(0, 0),
  }) : super(key: key);
  final FileEntity? entity;
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
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(12.w),
                child: Material(
                  borderRadius: BorderRadius.circular(12.w),
                  clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).surface1,
                  elevation: 2,
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
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                          Navigator.of(context).pop();
                          Get.to(
                            () => Responsive(
                              builder: (context, screenType) {
                                return  LoggerView(
                                  background: Theme.of(context).scaffoldBackgroundColor,
                                );
                              },
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 48.w,
                          child: Align(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                            sb.writeln('${log.time.to()} ${log.data.replaceAll(RegExp('\x1b\\[38;5;244m|\x1b\\[0m|\x1b\\[1;3[0-9]m|\x1b\\[1;0m'), '')}');
                          }
                          newFile.writeAsString(sb.toString());
                          showToast('日志输出到 ${dir}_$fileName');
                        },
                        child: SizedBox(
                          height: 48.w,
                          child: Align(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
      ],
    );
  }
}

extension TimeExt on DateTime {
  String to() {
    return '[${twoDigits(hour)}:${twoDigits(minute)}:${twoDigits(second)}]';
  }
}
