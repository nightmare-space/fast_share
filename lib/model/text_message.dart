import 'base_message.dart';

class TextMessage extends MessageBaseInfo {
  String content;

  TextMessage({
    this.content,
    String type,
    String data,
    String sendFrom,
  }) : super(
          data: data,
          type: type,
          msgType: 'text',
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
