import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:speed_share/pages/video_preview.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoItem extends StatefulWidget {
  final MessageVideoInfo info;
  final bool sendByUser;
  final String roomUrl;

  const VideoItem({Key key, this.info, this.sendByUser, this.roomUrl})
      : super(key: key);
  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  MessageVideoInfo info;

  @override
  void initState() {
    super.initState();
    info = widget.info;
  }

  final Dio dio = Dio();
  int count = 0;
  double fileDownratio = 0.0;
  Future<void> downloadFile(String urlPath) async {
    print(urlPath);
    Response<String> response = await dio.head<String>(urlPath);
    final int fullByte = int.tryParse(
      response.headers.value('content-length'),
    ); //得到服务器文件返回的字节大小
    // final String _human = getFileSize(_fullByte); //拿到可读的文件大小返回给用户
    print('fullByte -> $fullByte');
    final String savePath = RuntimeEnvir.filesPath + '/' + basename(urlPath);
    // print(savePath);
    await dio.download(
      urlPath,
      savePath,
      onReceiveProgress: (count, total) {
        this.count = count;
        final double process = count / total;
        Log.e(process);
        fileDownratio = process;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String url =
        widget.roomUrl.replaceAll('7000', '8002') + '/' + widget.info.filePath;
    String thumbnailUrl = widget.roomUrl.replaceAll('7000', '8002') +
        '/' +
        widget.info.thumbnailPath;
    UniqueKey key = UniqueKey();
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
              children: [
                InkWell(
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
                    child: Image.network(thumbnailUrl),
                  ),
                ),
                if (!widget.sendByUser && count != 0)
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
                      Text(
                        '${FileSizeUtils.getFileSize(count)}/${widget.info.fileSize}',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
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
                    showToast('视频链接已复制');
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
