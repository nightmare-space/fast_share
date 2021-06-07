import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:speed_share/pages/video_preview.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:path/path.dart';
import 'package:get/get.dart' hide Response;
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
  MessageFileInfo info;
  final Dio dio = Dio();
  CancelToken cancelToken = CancelToken();
  int count = 0;
  double fileDownratio = 0.0;
  // 网速
  String speed = '0';
  Timer timer;
  Future<void> downloadFile(String urlPath, String savePath) async {
    if (fileDownratio != 0.0) {
      showToast('已经在下载中了哦');
      return;
    }
    Response<String> response = await dio.head<String>(urlPath);
    final int fullByte = int.tryParse(
      response.headers.value('content-length'),
    ); //得到服务器文件返回的字节大小
    print('fullByte -> $fullByte');
    savePath = savePath + '/' + basename(urlPath);
    // print(savePath);
    computeNetSpeed();
    await dio.download(
      urlPath,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: (count, total) {
        this.count = count;
        fileDownratio = count / total;
        setState(() {});
      },
    );
    timer?.cancel();
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
    String url;
    if (widget.sendByUser) {
      url = 'http://127.0.0.1:8002' + widget.info.filePath;
    } else {
      url = widget.info.url + widget.info.filePath;
    }
    Log.e('fileitem url -> $url');
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
                buildPreviewWidget(),
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
                              SizedBox(
                                child: Text(
                                  '${widget.info.fileSize}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
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
        if (!widget.sendByUser)
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    if (GetPlatform.isWeb) {
                      await canLaunch(url)
                          ? await launch(url)
                          : throw 'Could not launch $url';
                      return;
                    }
                    if (GetPlatform.isDesktop) {
                      const confirmButtonText = 'Choose';
                      final directoryPath =
                          await FileSelectorPlatform.instance.getDirectoryPath(
                        confirmButtonText: confirmButtonText,
                      );
                      if (directoryPath == null) {
                        return;
                      }
                      downloadFile(url, directoryPath);
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
                      size: 18,
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

  UniqueKey key = UniqueKey();
  Widget buildPreviewWidget() {
    if (widget.info is MessageImgInfo) {
      String url;
      if (widget.sendByUser) {
        url = 'http://127.0.0.1:8002' + widget.info.filePath;
      } else {
        url = widget.info.url + widget.info.filePath;
      }
      return Hero(
        tag: key,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.to(
                Material(
                  color: AppColors.background,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Hero(
                        tag: key,
                        child: Image.network(url),
                      ),
                      SafeArea(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.clear),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            child: Image.network(
              url,
              width: 200,
            ),
          ),
        ),
      );
    } else if (widget.info is MessageVideoInfo) {
      MessageVideoInfo info = widget.info;
      String url;
      if (widget.sendByUser) {
        url = 'http://127.0.0.1:8002' + info.filePath;
      } else {
        url = info.url + info.filePath;
      }
      String thumbnailUrl;
      if (widget.sendByUser) {
        thumbnailUrl = 'http://127.0.0.1:8002' + info.thumbnailPath;
      } else {
        thumbnailUrl = info.url + info.thumbnailPath;
      }
      return InkWell(
        onTap: () {
          NiNavigator.of(Get.context).pushVoid(
            Material(
              child: Hero(
                tag: key,
                child: SamplePlayer(
                  url: url,
                ),
              ),
            ),
          );
        },
        child: Hero(
          tag: key,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.network(thumbnailUrl),
              Icon(
                Icons.play_circle,
                color: AppColors.accentColor,
                size: 48,
              )
            ],
          ),
        ),
      );
    }
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: widget.info.fileName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SvgPicture.asset(
              '${Config.flutterPackage}assets/icon/file.svg',
              width: 16,
              color: Colors.black,
            ),
          ),
        ),
      ]),
    );
  }
}
