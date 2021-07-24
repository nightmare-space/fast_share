import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';
import 'package:speed_share/config/assets.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/pages/model/message_dir_info.dart';
import 'package:speed_share/themes/app_colors.dart';

class DirMessageItem extends StatefulWidget {
  const DirMessageItem({
    Key key,
    this.info,
    this.sendByUser,
  }) : super(key: key);
  final bool sendByUser;
  final MessageDirInfo info;

  @override
  _DirMessageItemState createState() => _DirMessageItemState();
}

class _DirMessageItemState extends State<DirMessageItem> {
  MessageDirInfo info;
  final Dio dio = Dio();
  CancelToken cancelToken = CancelToken();
  int count = 0;
  double fileDownratio = 0.0;
  int downloadSize = 0;
  // 网速
  String speed = '0';
  Timer timer;
  Future<void> downloadFile(String urlPath, String savePath) async {
    if (fileDownratio != 0.0) {
      showToast('已经在下载中了哦');
      return;
    }
    await Directory(savePath + Platform.pathSeparator + widget.info.dirName)
        .create();
    for (String path in widget.info.paths) {
      Log.d(path);
      // .*?是非贪婪匹配，
      String relativePath =
          path.replaceAll(RegExp('.*?${widget.info.dirName}/'), '/');
      Log.e(relativePath);
      if (path.endsWith('/')) {
        // await Directory(
        //   savePath +
        //       Platform.pathSeparator +
        //       widget.info.dirName +
        //       Platform.pathSeparator +
        //       relativePath,
        // ).create();
      } else {
        String tmpSavePath =
            savePath + '/' + widget.info.dirName + '/' + relativePath;
        // print(savePath);
        computeNetSpeed();
        Log.e(urlPath + '$path' + '?download=true');
        await dio.download(
          urlPath + '$path' + '?download=true',
          tmpSavePath,
          cancelToken: cancelToken,
          onReceiveProgress: (count, total) {
            this.count = downloadSize + count;
            fileDownratio = this.count / widget.info.fullSize;
            setState(() {});
            if (count == total) {
              downloadSize += total;
            }
          },
        );
        timer?.cancel();
      }
    }
  }

  Future<void> computeNetSpeed() async {
    int tmpCount = 0;
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
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
    String urlPrifix;
    if (widget.sendByUser) {
      urlPrifix = 'http://127.0.0.1:${Config.shelfPort}';
    } else {
      urlPrifix = info.urlPrifix;
    }
    print('urlPrifix -> $urlPrifix');
    Color background = AppColors.surface;
    if (widget.sendByUser) {
      background = AppColors.sendByUser;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          widget.sendByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SvgPicture.asset(
                        Assets.dir,
                        width: 32,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${widget.info.dirName}',
                        style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!widget.sendByUser && !GetPlatform.isWeb)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0)),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.black12,
                          valueColor: AlwaysStoppedAnimation(
                            fileDownratio == 1.0 ? Colors.blue : Colors.red,
                          ),
                          value: fileDownratio,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(builder: (_) {
                            if (fileDownratio == 1.0) {
                              return Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.green,
                              );
                            }
                            return Text(
                              '$speed/s',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            );
                          }),
                          Row(
                            children: [
                              SizedBox(
                                child: Text(
                                  '${FileSizeUtils.getFileSize(count)}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Text(
                                '/',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              Builder(builder: (context) {
                                if (!widget.info.canDownload) {
                                  return SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Text(
                                  '${FileSizeUtils.getFileSize(widget.info.fullSize)}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                );
                              }),
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
        if (!widget.sendByUser)
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    // if (GetPlatform.isWeb) {
                    //   Log.e('web download');
                    //   await canLaunch(url)
                    //       ? await launch(url + '?download=true')
                    //       : throw 'Could not launch $url';
                    //   return;
                    // }
                    if (GetPlatform.isDesktop) {
                      const confirmButtonText = 'Choose';
                      final dir =
                          await FileSelectorPlatform.instance.getDirectoryPath(
                        confirmButtonText: confirmButtonText,
                      );
                      if (dir == null) {
                        return;
                      }
                      downloadFile(urlPrifix, dir);
                    } else {
                      Directory dataDir = Directory('/sdcard/SpeedShare');
                      if (!dataDir.existsSync()) {
                        dataDir.createSync();
                      }
                      downloadFile(urlPrifix, '/sdcard/SpeedShare');
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.file_download,
                      size: 18,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {},
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.content_copy,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
