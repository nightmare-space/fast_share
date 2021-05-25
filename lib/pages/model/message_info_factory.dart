import 'model.dart';

class MessageInfoFactory {
  static MessageBaseInfo fromJson(Map<String, dynamic> json) {
    String msgType = json['msgType'];
    switch (msgType) {
      case 'img':
        return MessageImgInfo.fromJson(json);
        break;
      case 'video':
        print('video video');
        return MessageVideoInfo.fromJson(json);
        break;
      case 'text':
        return MessageTextInfo.fromJson(json);
        break;
      default:
        return MessageBaseInfo.fromJson(json);
    }
  }
}
