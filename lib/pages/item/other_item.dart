import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:path/path.dart';
import 'package:get/get.dart' hide Response;
import 'package:url_launcher/url_launcher.dart';

class OtherItem extends StatefulWidget {
  final MessageFileInfo info;
  final bool sendByUser;
  final String roomUrl;

  const OtherItem({
    Key key,
    this.info,
    this.sendByUser,
    this.roomUrl,
  }) : super(key: key);
  @override
  _OtherItemState createState() => _OtherItemState();
}

class _OtherItemState extends State<OtherItem> {
  MessageFileInfo info;
  final Dio dio = Dio();
  CancelToken cancelToken = CancelToken();
  int count = 0;
  double fileDownratio = 0.0;
  // 网速
  String speed = '0';
  Timer timer;
  Future<void> downloadFile(String urlPath) async {
    print(urlPath);
    Response<String> response = await dio.head<String>(urlPath);
    final int fullByte = int.tryParse(
      response.headers.value('content-length'),
    ); //得到服务器文件返回的字节大小
    print('fullByte -> $fullByte');
    final String savePath = RuntimeEnvir.filesPath + '/' + basename(urlPath);
    // print(savePath);
    computeNetSpeed();
    await dio.download(
      urlPath,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: (count, total) {
        this.count = count;
        final double process = count / total;
        // Log.e(process);
        fileDownratio = process;
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
      Log.e('diff -> $diff');
      // 乘以2是因为半秒测的一次
      speed = FileSizeUtils.getFileSize(diff * 2);
      // *2 的原因是半秒测的一次
      Log.e('网速 -> $speed');
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
      url = 'http://127.0.0.1:8002/' + widget.info.filePath;
    } else {
      url = widget.info.url + '/' + widget.info.filePath;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          widget.sendByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.info.fileName),
                if (!widget.sendByUser)
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
                            fileDownratio == 1.0
                                ? Colors.lightGreen
                                : Colors.red,
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
                          Text(
                            '$speed/s',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                child: Text(
                                  '${FileSizeUtils.getFileSize(count)}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Text(
                                '/',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  '${widget.info.fileSize}',
                                  style: TextStyle(
                                    color: Colors.black54,
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
                    print(url);
                    downloadFile(url);
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
                    showToast('文件下载链接已复制');
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
}
