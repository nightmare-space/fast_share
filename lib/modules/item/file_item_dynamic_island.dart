import 'dart:io';
import 'package:flutter/material.dart' hide Router;
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/download_controller.dart';
import 'package:speed_share/app/controller/setting_controller.dart';
import 'package:speed_share/model/model.dart';
import 'package:path/path.dart';
import 'package:get/get.dart' hide Response;
import 'package:speed_share/modules/widget/icon.dart';
import 'package:speed_share/utils/ext_util.dart';

class FileDynamicIsland extends StatefulWidget {
  /// 消息model
  final FileMessage? info;

  /// 是否是本机发送的消息
  final bool? sendByUser;

  const FileDynamicIsland({
    Key? key,
    this.info,
    this.sendByUser,
  }) : super(key: key);
  @override
  State createState() => _FileDynamicIslandState();
}

class _FileDynamicIslandState extends State<FileDynamicIsland> {
  ChatController chatController = Get.find();
  SettingController settingController = Get.find();
  DownloadController downloadController = Get.find();
  FileMessage? info;

  DateTime? startTime;
  bool isStarted = false;
  // 执行下载文件

  @override
  void initState() {
    super.initState();
    info = widget.info;
    // 开启自动下载，且是来自其他设备的消息
    if (!GetPlatform.isWeb && canAutoDownload()) {
      downloadController.downloadFile(url, settingController.savePath);
    }
  }

  bool canAutoDownload() {
    if (widget.sendByUser!) {
      return false;
    }
    if (downloadController.progress.containsKey(url) && downloadController.progress[url]!.progress != 0.0) {
      return false;
    }
    if (!settingController.enableAutoDownload) return false;
    String type = url.getType;
    String savePath = '${settingController.savePath}/$type/${basename(url)}';
    File file = File(savePath);
    if (!file.existsSync()) {
      return true;
    }
    int len = file.lengthSync();
    if (file.existsSync()) {
      if (widget.info!.fileSize != FileSizeUtils.getFileSize(len)) return true;
      if (widget.info!.fileSize == FileSizeUtils.getFileSize(len)) return false;
    }
    return true;
  }

  String get url {
    String url;
    if (widget.sendByUser!) {
      url = 'http://127.0.0.1:${chatController.shelfBindPort}${widget.info!.filePath}';
    } else {
      url = widget.info!.url! + widget.info!.filePath!;
    }
    return url;
  }

  Offset? offset;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10.w),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTapDown: (details) {
          offset = details.globalPosition;
        },
        child: body(context),
      ),
    );
  }

  Padding body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 200.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (context) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // if (fileDownratio == 1.0 && !timer.isActive) {
                  //   OpenFile.open(savePath);
                  // }
                },
                child: buildPreviewWidget(url),
              );
            }),
            // 展示下载进度条
            if (!widget.sendByUser! && !GetPlatform.isWeb)
              GetBuilder<DownloadController>(builder: (context) {
                DownloadInfo info = downloadController.getInfo(url)!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 8.w,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                      child: Builder(builder: (context) {
                        double pro = info.progress;
                        return LinearProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation(
                            pro == 1.0 ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.4),
                          ),
                          value: pro,
                        );
                      }),
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(builder: (_) {
                          double pro = downloadController.getProgress(url);
                          if (pro == 1.0) {
                            return Icon(
                              Icons.check,
                              size: 16.w,
                              color: Colors.green,
                            );
                          }
                          return Text(
                            '${info.speed}/s',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12.w,
                            ),
                          );
                        }),
                        Row(
                          children: [
                            SizedBox(
                              child: Text(
                                FileSizeUtils.getFileSize(info.count)!,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12.w,
                                ),
                              ),
                            ),
                            Text(
                              '/',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12.w,
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                widget.info!.fileSize!,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }

  UniqueKey key = UniqueKey();
  Widget buildPreviewWidget(String url) {
    return InkWell(
      child: Row(
        children: [
          getIconByExt(url),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              widget.info!.fileName!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
