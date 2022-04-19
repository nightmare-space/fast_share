import 'base_message.dart';

class MessageTextInfo extends MessageBaseInfo {
  String content;

  MessageTextInfo({
    this.content,
    String msgType = 'text',
    String type,
    String data,
    String sendFrom,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
          deviceName: sendFrom,
        );

  MessageTextInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    content = json['content'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['content'] = content;
    return data;
  }
}
