import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/model/model.dart';
import 'package:speed_share/modules/item/text_item.dart';
import 'broswer_file_item.dart';
import 'dir_item.dart';
import 'file_item.dart';

class MessageItemFactory {
  static Widget getMessageItem(MessageBaseInfo info, bool sendByUser) {
    Widget child;
    if (info is TextMessage) {
      child = TextMessageItem(
        info: info,
        sendByUser: sendByUser,
      );
    } else if (info is FileMessage) {
      child = FileItem(
        info: info,
        sendByUser: sendByUser,
      );
    } else if (info is DirMessage) {
      child = DirMessageItem(
        info: info,
        sendByUser: sendByUser,
      );
    } else if (info is BroswerFileMessage) {
      child = BroswerFileItem(
        info: info,
        sendByUser: sendByUser,
      );
    }
    if (child == null) {
      return null;
    }
    return Align(
      alignment: sendByUser ? Alignment.centerLeft : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 8.w,
        ),
        child: Column(
          crossAxisAlignment:
              sendByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (info.deviceName != null)
              Row(
                mainAxisAlignment: sendByUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Device.getColor(info.deviceType).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Center(
                      child: Text(
                        info.deviceName ?? '',
                        style: TextStyle(
                          fontSize: 12.w,
                          color: Device.getColor(info.deviceType),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  if (info is ClipboardMessage)
                    Container(
                      decoration: BoxDecoration(
                        color:
                            Device.getColor(info.deviceType).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: EdgeInsets.only(left: 4.w),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Center(
                        child: Text(
                          '剪切板',
                          style: TextStyle(
                            fontSize: 12.w,
                            color: Device.getColor(info.deviceType),
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
