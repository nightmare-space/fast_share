import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/generated/l10n.dart';
import 'package:speed_share/model/model.dart';
import 'package:file_selector/file_selector.dart';

class DirMessageItem extends StatefulWidget {
  const DirMessageItem({
    Key? key,
    this.info,
    this.sendByUser,
  }) : super(key: key);
  final bool? sendByUser;
  final DirMessage? info;

  @override
  State createState() => _DirMessageItemState();
}

class _DirMessageItemState extends State<DirMessageItem> {
  ChatController chatController = Get.find();
  DirMessage? info;
  final Dio dio = Dio();
  CancelToken cancelToken = CancelToken();
  int count = 0;
  double fileDownratio = 0.0;
  int downloadSize = 0;
  // 网速
  String? speed = '0';
  Timer? timer;
  Future<void> downloadFile(String? urlPath, String savePath) async {
    if (fileDownratio != 0.0) {
      showToast(S.current.fileIsDownloading);
      return;
    }
    String baseDirPath = '$savePath/${widget.info!.dirName}';
    // 这儿可能已经有一个文件名被占用了
    try {
      await Directory(baseDirPath).create();
    } catch (e) {
      showToast('${S.current.exceptionOrcur}：$e');
      return;
    }
    computeNetSpeed();
    for (String? path in widget.info!.paths!) {
      Log.d(path);
      // .*?是非贪婪匹配，
      String relativePath = path!.replaceAll(RegExp('.*?${widget.info!.dirName}/'), '/');
      // Log.e(relativePath);
      if (path.endsWith('/')) {
      } else {
        String tmpSavePath = '$savePath/${widget.info!.dirName}/$relativePath';
        // print(savePath);
        // Log.e(urlPath + '$path' + '?download=true');
        await dio.download(
          '$urlPath$path?download=true',
          tmpSavePath,
          cancelToken: cancelToken,
          onReceiveProgress: (count, total) {
            this.count = downloadSize + count;
            fileDownratio = this.count / widget.info!.fullSize!;
            setState(() {});
            if (count == total) {
              downloadSize += total;
            }
          },
        );
      }
    }
    timer?.cancel();
  }

  Future<void> computeNetSpeed() async {
    int tmpCount = 0;
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      int diff = count - tmpCount;
      tmpCount = count;
      // Log.e('diff -> $diff');
      // 乘以2是因为半秒测的一次
      speed = FileUtil.formatBytes(diff * 2);
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
    String? urlPrifix;
    if (widget.sendByUser!) {
      urlPrifix = 'http://127.0.0.1:${chatController.messageBindPort}';
    } else {
      urlPrifix = info!.urlPrifix;
    }
    Log.v('urlPrifix -> $urlPrifix');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: widget.sendByUser! ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SvgPicture.asset(
                        'assets/icon/dir.svg',
                        width: 32,
                        color: Colors.black,
                        package: 'file_manager_view',
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.info!.dirName!,
                        style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.bold,
                          fontSize: 16.w,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!widget.sendByUser! && !GetPlatform.isWeb)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 8.w,
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.black12,
                          valueColor: AlwaysStoppedAnimation(
                            fileDownratio == 1.0 ? Colors.blue : Colors.red,
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
                            if (fileDownratio == 1.0) {
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
                                  FileUtil.formatBytes(count),
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
                              Builder(builder: (context) {
                                return Text(
                                  FileUtil.formatBytes(widget.info!.fullSize!),
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.w,
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
        if (!widget.sendByUser!)
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
                      final dir = await getDirectoryPath(
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
                      downloadFile(urlPrifix, '/sdcard/SpeedShare/文件夹');
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
                  onTap: () async {},
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
}
