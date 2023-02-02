import 'text_message.dart';

class ClipboardMessage extends TextMessage {
  ClipboardMessage({
    String? content,
    String? sendFrom,
  }) : super(
          msgType: 'clip',
          sendFrom: sendFrom,
          content: content,
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
