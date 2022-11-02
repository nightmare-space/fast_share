import 'base_message.dart';

class TextMessage extends MessageBaseInfo {
  String content;

  TextMessage({
    this.content,
    String sendFrom,
    String msgType = 'text',
  }) : super(
          msgType: msgType,
          deviceName: sendFrom,
        );

  TextMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    content = json['content'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['content'] = content;
    return data;
  }
}
