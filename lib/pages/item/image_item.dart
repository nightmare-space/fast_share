import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/model/message_img_info.dart';
import 'package:speed_share/themes/theme.dart';

class ImageItem extends StatefulWidget {
  final MessageImgInfo info;
  final bool sendByUser;

  const ImageItem({Key key, this.info, this.sendByUser}) : super(key: key);
  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  MessageImgInfo info;

  @override
  void initState() {
    super.initState();
    info = widget.info;
  }

  @override
  Widget build(BuildContext context) {
    UniqueKey key = UniqueKey();
    String url = 'http://${info.address[2]}:8002/${info.url}';
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
                child: Column(
                  children: [
                    Hero(
                      tag: key,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            NiNavigator.of(Get.context).pushVoid(
                              Material(
                                child: Hero(
                                  tag: key,
                                  child: Image.network(url),
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
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
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
                    showToast('图片链接已复制');
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
