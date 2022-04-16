import 'dart:async';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:dio_range_download/dio_range_download.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:path/path.dart';
import 'package:get/get.dart' hide Response;
import 'package:speed_share/utils/path_util.dart';
import 'package:speed_share/v2/ext_util.dart';
import 'package:speed_share/v2/icon.dart';
import 'package:url_launcher/url_launcher.dart';

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
  _FileItemState createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  ChatController chatController = Get.find();
  MessageFileInfo info;
  final Dio dio = Dio();
  CancelToken cancelToken = CancelToken();
  int count = 0;
  double fileDownratio = 0.0;
  // 网速
  String speed = '0';
  Timer timer;
  String savePath;

  DateTime startTime;
  bool isStarted = false;
  // 执行下载文件
  Future<void> downloadFile(String urlPath, String savePath) async {
    if (fileDownratio != 0.0) {
      showToast('已经在下载中了哦');
      return;
    }
    String type = urlPath.getType;
    this.savePath = savePath = savePath + '/$type/' + basename(urlPath);
    File saveFile = File(getSafePath(savePath));
    this.savePath = saveFile.path;
    Log.d(saveFile.path);
    computeNetSpeed();
    Response res = await RangeDownload.downloadWithChunks(
      urlPath + '?download=true', saveFile.path,
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
      // *2 的原因是半秒测的一次
      // Log.e('网速 -> $speed');
    });
  }

  @override
  void initState() {
    super.initState();
    info = widget.info;
  }

  @override
  void dispose() {
    cancelToken.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String url;
    if (widget.sendByUser) {
      url = 'http://127.0.0.1:${chatController.shelfBindPort}' +
          widget.info.filePath;
    } else {
      url = widget.info.url + widget.info.filePath;
    }
    // Log.e('fileitem url -> $url');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          widget.sendByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: widget.sendByUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (info.sendFrom != null)Container(
              decoration: BoxDecoration(
                color: const Color(0xffED796A).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Center(
                child: Text(
                  info.sendFrom,
                  style: TextStyle(
                    height: 1,
                    fontSize: 12.w,
                    color: const Color(0xffED796A),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 4.w,
            ),
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      void Function() onTap;
                      if (fileDownratio == 1.0 && !timer.isActive) {
                        onTap = () {
                          OpenFile.open(savePath);
                        };
                      }
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onTap,
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25.0)),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.black12,
                              valueColor: AlwaysStoppedAnimation(
                                fileDownratio == 1.0
                                    ? Colors.blue
                                    : Theme.of(context).primaryColor,
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
            ),
          ],
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
                      Log.e('web download');
                      await canLaunch(url)
                          ? await launch(url + '?download=true')
                          : throw 'Could not launch $url';
                      return;
                    }
                    if (GetPlatform.isDesktop) {
                      const confirmButtonText = 'Choose';
                      final dir =
                          await FileSelectorPlatform.instance.getDirectoryPath(
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

  UniqueKey key = UniqueKey();
  Widget buildPreviewWidget(String url) {
    MessageFileInfo info = widget.info;
    // if (info.fileName.isVideoFileName || info.fileName.endsWith('.mkv')) {
    //   return InkWell(
    //     onTap: () async {
    //       if (GetPlatform.isWeb) {
    //         await canLaunch(url)
    //             ? await launch(url)
    //             : throw 'Could not launch $url';
    //         return;
    //       }
    //       NiNavigator.of(Get.context).pushVoid(
    //         Material(
    //           child: Hero(
    //             tag: key,
    //             child: SerieExample(
    //               url: url,
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //     child: Hero(
    //       tag: key,
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           getIconByExt(info.fileName),
    //           SizedBox(width: 8.w),
    //           Expanded(
    //             child: Text(
    //               widget.info.fileName,
    //               style: TextStyle(
    //                 color: Colors.black,
    //                 // fontWeight: FontWeight.bold,
    //                 fontSize: 14.w,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    return Row(
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
    );
  }
}
