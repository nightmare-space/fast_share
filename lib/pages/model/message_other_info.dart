import 'message_base_info.dart';

class MessageOtherInfo extends MessageBaseInfo {
  String title;
  String url;

  MessageOtherInfo({
    this.title,
    String msgType,
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
        );

  MessageOtherInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['title'] = title;
    data['url'] = url;
    return data;
  }
}
