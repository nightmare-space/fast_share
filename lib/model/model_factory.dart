import 'model.dart';

class MessageInfoFactory {
  /// 根据不同的json返回不同的对象
  static MessageBaseInfo? fromJson(Map<String, dynamic> json) {
    String? msgType = json['msgType'];
    switch (msgType) {
      case 'file':
        return FileMessage.fromJson(json);
      case 'text':
        return TextMessage.fromJson(json);
      case 'dir':
        return DirMessage.fromJson(json);
      case 'dirPart':
        return DirPartMessage.fromJson(json);
      case 'clip':
        return ClipboardMessage.fromJson(json);
      case 'webfile':
        return BroswerFileMessage.fromJson(json);
      case 'notify':
        return NotifyMessage.fromJson(json);
      case 'join':
        return JoinMessage.fromJson(json);
    }
    return null;
  }
}
