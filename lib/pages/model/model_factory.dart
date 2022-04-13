import 'package:speed_share/pages/model/join_message.dart';

import 'model.dart';

class MessageInfoFactory {
  /// 根据不同的json返回不同的对象
  static MessageBaseInfo fromJson(Map<String, dynamic> json) {
    String msgType = json['msgType'];
    switch (msgType) {
      case 'file':
        return MessageFileInfo.fromJson(json);
        break;
      case 'text':
        return MessageTextInfo.fromJson(json);
        break;
      case 'dir':
        return MessageDirInfo.fromJson(json);
        break;
      case 'dirPart':
        return MessageDirPartInfo.fromJson(json);
        break;
      case 'tip':
        return MessageTipInfo.fromJson(json);
        break;
      case 'qr':
        return QRMessage.fromJson(json);
      case 'webfile':
        return BroswerFileMessage.fromJson(json);
      case 'notify':
        return NotifyMessage.fromJson(json);
      case 'join':
        return JoinMessage.fromJson(json);
        break;
    }
    return null;
  }
}
