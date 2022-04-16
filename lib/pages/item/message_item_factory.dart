import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/item/text_item.dart';
import 'package:speed_share/pages/model/model.dart';
import 'broswer_file_item.dart';
import 'dir_item.dart';
import 'file_item.dart';
import 'qr_item.dart';

class MessageItemFactory {
  static Widget getMessageItem(MessageBaseInfo info, bool sendByUser) {
    Widget child;
    if (info is MessageTextInfo) {
      child = TextMessageItem(
        info: info,
        sendByUser: sendByUser,
      );
    } else if (info is MessageTipInfo) {
      return Center(
        child: Text(
          info.content,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.w,
          ),
        ),
      );
    } else if (info is MessageFileInfo) {
      child = FileItem(
        info: info,
        sendByUser: sendByUser,
      );
    } else if (info is MessageDirInfo) {
      child = DirMessageItem(
        info: info,
        sendByUser: sendByUser,
      );
    } else if (info is QRMessage) {
      child = QrMessageItem(
        data: info.content,
      );
    } else if (info is BroswerFileMessage) {
      child = BroswerFileItem(
        info: info,
        sendByUser: sendByUser,
      );
    }
    child ?? const Text('不支持的消息类型');
    return Align(
      alignment: sendByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 8.w,
        ),
        child: child,
      ),
    );
  }
}
