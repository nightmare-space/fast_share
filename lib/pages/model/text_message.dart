import 'base_message.dart';

class MessageTextInfo extends MessageBaseInfo {
  String content;

  MessageTextInfo({
    this.content,
    String msgType,
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
        );

  MessageTextInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['content'] = content;
    return data;
  }
}
