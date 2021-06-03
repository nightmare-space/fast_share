import 'message_base_info.dart';

class MessageQrInfo extends MessageBaseInfo {
  String content;

  MessageQrInfo({
    this.content,
    String msgType,
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
        );

  MessageQrInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['content'] = content;
    return data;
  }
}
