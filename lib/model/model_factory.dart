import 'model.dart';

class MessageInfoFactory {
  /// 根据不同的json返回不同的对象
  static MessageBaseInfo? fromJson(Map<String, dynamic> json) {
    String? msgType = json['msgType'];
    switch (msgType) {
      case 'file':
        return FileMessage.fromJson(json);
        break;
      case 'text':
        return TextMessage.fromJson(json);
        break;
      case 'dir':
        return DirMessage.fromJson(json);
        break;
      case 'dirPart':
        return DirPartMessage.fromJson(json);
        break;
      case 'clip':
        return ClipboardMessage.fromJson(json);
        break;
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
