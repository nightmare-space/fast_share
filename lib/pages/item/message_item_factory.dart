import 'package:flutter/material.dart';
import 'package:speed_share/pages/item/text_item.dart';
import 'package:speed_share/pages/model/model.dart';
import 'file_item.dart';
import 'qr_item.dart';

class MessageItemFactory {
  static Widget getMessageItem(MessageBaseInfo info, bool sendByUser) {
    Widget child;
    if (info is MessageTextInfo) {
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
      child = FileItem(
        info: info,
        sendByUser: sendByUser,
      );
    } else if (info is MessageQrInfo) {
      child = QrMessageItem(
        data: info.content,
        sendByUser: sendByUser,
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
}
