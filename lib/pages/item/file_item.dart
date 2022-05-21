import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_range_download/dio_range_download.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/setting_controller.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:path/path.dart';
import 'package:get/get.dart' hide Response;
import 'package:speed_share/themes/theme.dart';
import 'package:speed_share/utils/path_util.dart';
import 'package:speed_share/utils/ext_util.dart';
import 'package:speed_share/v2/icon.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FileItem extends StatefulWidget {
  final MessageFileInfo info;
  final bool sendByUser;
  final String roomUrl;

  const FileItem({
    Key key,
    this.info,
    this.sendByUser,
    this.roomUrl,
  }) : super(key: key);
  @override
  State createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  ChatController chatController = Get.find();
  SettingController settingController = Get.find();
  MessageFileInfo info;
  final Dio dio = Dio();
  CancelToken cancelToken = CancelToken();
  int count = 0;
  double fileDownratio = 0.0;
  // 网速
  String speed = '0';
  Timer timer;

  DateTime startTime;
  bool isStarted = false;
  // 执行下载文件
  Future<void> downloadFile(String urlPath, String dir) async {
    if (fileDownratio != 0.0) {
      showToast('已经在下载中了哦');
      return;
    }

    String savePath = getSavePath(urlPath, dir);
    computeNetSpeed();
    Response res = await RangeDownload.downloadWithChunks(
      '$urlPath?download=true', savePath,
      // isRangeDownload: false, //Support normal download
      maxChunk: 4,
      // dio: Dio(),//Optional parameters "dio".Convenient to customize request settings.
      // cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        count = received;
        fileDownratio = received / total;
        setState(() {});
        if (!isStarted) {
          startTime = DateTime.now();
          isStarted = true;
        }
      },
    );
    // await dio.download(
    //   urlPath + '?download=true',
    //   saveFile.path,
    //   cancelToken: cancelToken,
    //   onReceiveProgress: (count, total) {
    //     this.count = count;
    //     fileDownratio = count / total;
    //     setState(() {});
    //   },
    // );
    timer?.cancel();
    setState(() {});
  }

  // 计算网速
  Future<void> computeNetSpeed() async {
    int tmpCount = 0;
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      int diff = count - tmpCount;
      tmpCount = count;
      // Log.e('diff -> $diff');
      // 乘以2是因为半秒测的一次
      speed = FileSizeUtils.getFileSize(diff * 2);
      // Log.e('网速 -> $speed');
    });
  }

  @override
  void initState() {
    super.initState();
    info = widget.info;
    // 开启自动下载，且是来自其他设备的消息
    if (canAutoDownload()) {
      downloadFile(url, '/sdcard/SpeedShare');
    }
  }

  @override
  void dispose() {
    cancelToken.cancel();
    timer?.cancel();
    super.dispose();
  }

  String getSavePath(String url, String dir) {
    String type = url.getType;
    String savePath = '$dir/$type/${basename(url)}';
    return getSafePath(savePath);
  }

  bool canAutoDownload() {
    return settingController.enableAutoDownload && !widget.sendByUser;
  }

  String get url {
    String url;
    if (widget.sendByUser) {
      url =
          'http://127.0.0.1:${chatController.shelfBindPort}${widget.info.filePath}';
    } else {
      url = widget.info.url + widget.info.filePath;
    }
    return url;
  }

  Offset offset;
  @override
  Widget build(BuildContext context) {
    // Log.e('fileitem url -> $url');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          widget.sendByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.w),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onLongPress: () {
              Get.dialog(
                Menu(
                  offset: offset,
                ),
                useSafeArea: false,
                barrierColor: Colors.black12,
              );
            },
            child: GestureDetector(
              onTapDown: (details) {
                offset = details.globalPosition;
              },
              child: body(context),
            ),
          ),
        ),
        // 展示下载按钮
        if (!widget.sendByUser)
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    if (GetPlatform.isWeb) {
                      Log.e('web download $url');
                      await canLaunchUrlString(url)
                          ? await launchUrlString('$url?download=true')
                          : throw 'Could not launch $url';
                      return;
                    }
                    if (GetPlatform.isDesktop) {
                      const confirmButtonText = 'Choose';
                      final dir = await getDirectoryPath(
                        confirmButtonText: confirmButtonText,
                      );
                      if (dir == null) {
                        return;
                      }
                      Log.e(' -> $url');
                      downloadFile(url, dir);
                    } else {
                      Directory dataDir = Directory('/sdcard/SpeedShare');
                      if (!dataDir.existsSync()) {
                        dataDir.createSync();
                      }
                      downloadFile(url, '/sdcard/SpeedShare');
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.file_download,
                      size: 18.w,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    showToast('链接已复制');
                    await Clipboard.setData(ClipboardData(text: url));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.content_copy,
                      size: 18.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
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
            if (!widget.sendByUser && !GetPlatform.isWeb)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 8.w,
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    child: LinearProgressIndicator(
                      backgroundColor: Theme.of(context).colorScheme.surface3,
                      valueColor: AlwaysStoppedAnimation(
                        fileDownratio == 1.0
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColor.withOpacity(0.4),
                      ),
                      value: fileDownratio,
                    ),
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (_) {
                        // timer.isActive说明正在下载，说明文件完整下载了，但是还没有合并
                        if (fileDownratio == 1.0 && timer.isActive) {
                          return Text(
                            '合并文件中',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.w,
                            ),
                          );
                        }
                        if (fileDownratio == 1.0 && !timer.isActive) {
                          return Icon(
                            Icons.check,
                            size: 16.w,
                            color: Colors.green,
                          );
                        }
                        return Text(
                          '$speed/s',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12.w,
                          ),
                        );
                      }),
                      Row(
                        children: [
                          SizedBox(
                            child: Text(
                              FileSizeUtils.getFileSize(count),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12.w,
                              ),
                            ),
                          ),
                          Text(
                            '/',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.w,
                            ),
                          ),
                          SizedBox(
                            child: Text(
                              widget.info.fileSize,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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
              widget.info.fileName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({Key key, this.offset}) : super(key: key);
  final Offset offset;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          top: widget.offset.dy,
          left: widget.offset.dx,
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(10.w),
              child: SizedBox(
                width: 120.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        height: 40.w,
                        child: const Center(child: Text('分享')),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        height: 40.w,
                        child: const Center(child: Text('删除')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
