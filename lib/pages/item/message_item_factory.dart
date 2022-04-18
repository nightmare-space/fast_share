import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/item/text_item.dart';
import 'package:speed_share/pages/model/model.dart';
import 'broswer_file_item.dart';
import 'dir_item.dart';
import 'file_item.dart';
import 'qr_item.dart';

Color getColor(int type) {
  switch (type) {
    case 0:
      return Color(0xffED796A);
      break;
    case 1:
      return Color(0xff6A6DED);
      break;
    case 2:
      return Color(0xff317DEE);
      break;
    default:
      return Colors.indigo;
  }
}

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
    if (child == null) {
      return const SizedBox();
    }
    return Align(
      alignment: sendByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 8.w,
        ),
        child: Column(
          children: [
            if (info.sendFrom != null)
              Row(
                mainAxisAlignment: sendByUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: getColor(info.deviceType).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Center(
                      child: Text(
                        info.sendFrom ?? '',
                        style: TextStyle(
                          height: 1,
                          fontSize: 12.w,
                          color: getColor(info.deviceType),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 4.w,
            ),
            child,
          ],
        ),
      ),
    );
  }
}
