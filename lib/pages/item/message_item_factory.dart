import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/item/image_item.dart';
import 'package:speed_share/pages/item/text_item.dart';
import 'package:speed_share/pages/model/model.dart';
import '../video_preview.dart';
import 'other_item.dart';
import 'video_item.dart';

Widget messageItem(MessageBaseInfo info, bool sendByUser, String roomUrl) {
  Widget child;
  if (info is MessageImgInfo) {
    child = ImageItem(
      info: info,
      sendByUser: sendByUser,
      roomUrl: roomUrl,
    );
  } else if (info is MessageVideoInfo) {
    child = VideoItem(
      info: info,
      sendByUser: sendByUser,
      roomUrl: roomUrl,
    );
  } else if (info is MessageTextInfo) {
    child = TextMessageItem(
      data: info.content,
      sendByUser: sendByUser,
    );
  } else if (info is MessageTipInfo) {
    return Center(
      child: Text(
        info.content,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  } else if (info is MessageFileInfo) {
    child = OtherItem(
      info: info,
      sendByUser: sendByUser,
      roomUrl: roomUrl,
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
      child: child,
    ),
  );
}
