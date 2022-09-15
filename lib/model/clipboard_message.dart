import 'text_message.dart';

class ClipboardMessage extends TextMessage {
  String content;

  ClipboardMessage({
    this.content,
    String type,
    String data,
    String sendFrom,
  }) : super(
          data: data,
          type: type,
          msgType: 'clip',
          sendFrom: sendFrom,
        );

  ClipboardMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    content = json['content'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['content'] = content;
    return data;
  }
}
