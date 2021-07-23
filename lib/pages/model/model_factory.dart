import 'model.dart';

class MessageInfoFactory {
  /// 根据不同的json返回不同的对象
  static MessageBaseInfo fromJson(Map<String, dynamic> json) {
    String msgType = json['msgType'];
    switch (msgType) {
      case 'img':
        return MessageImgInfo.fromJson(json);
        break;
      case 'video':
        return MessageVideoInfo.fromJson(json);
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
        return MessageQrInfo.fromJson(json);
        break;
      default:
        return MessageFileInfo.fromJson(json);
    }
  }
}
