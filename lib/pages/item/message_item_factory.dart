import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/model/model.dart';
import 'package:speed_share/themes/theme.dart';

import '../video_preview.dart';

Widget messageItem(MessageBaseInfo info, bool sendByUser) {
  Widget child;
  if (info is MessageImgInfo) {
    UniqueKey key = UniqueKey();
    child = Column(
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
                      child: Image.network(
                        info.url,
                        width: 120,
                      ),
                    ),
                  ),
                );
              },
              child: Image.network(
                info.url,
                width: 120,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.preview,
                      size: 18,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
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
                    await Clipboard.setData(ClipboardData(
                      text: info.url,
                    ));
                    showToast('链接已复制');
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
        ),
      ],
    );
  } else if (info is MessageVideoInfo) {
    UniqueKey key = UniqueKey();
    child = InkWell(
      onTap: () {
        NiNavigator.of(Get.context).pushVoid(
          Material(
            child: Hero(
              tag: key,
              child: SamplePlayer(
                url: info.url,
              ),
            ),
          ),
        );
      },
      child: Hero(
        tag: key,
        child: Text('视频'),
      ),
    );
  } else if (info is MessageTextInfo) {
    child = Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.red,
          selectionColor: Color(0xffede8f8),
        ),
      ),
      child: SelectableText(
        info.content,
        cursorColor: Color(0xffede8f8),
      ),
    );
  }
  child ?? Text('不支持的消息类型');
  return Align(
    alignment: sendByUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8,
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    ),
  );
}
