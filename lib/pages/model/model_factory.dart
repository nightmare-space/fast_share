import 'message_base_info.dart';
import 'message_file_info.dart';
import 'message_qr_info.dart';
import 'message_text_info.dart';
import 'message_tip_info.dart';

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
