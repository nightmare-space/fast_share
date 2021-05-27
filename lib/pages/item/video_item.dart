import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:speed_share/pages/video_preview.dart';
import 'package:speed_share/themes/theme.dart';

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
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: InkWell(
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
                  child: SizedBox(
                    width: 200,
                    child: Hero(
                      tag: key,
                      child: Image.network(thumbnailUrl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!widget.sendByUser)
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {},
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
                    String data;
                    showToast('视频链接已复制');
                    await Clipboard.setData(ClipboardData(
                      text: data,
                    ));
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
