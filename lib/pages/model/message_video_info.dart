import 'message_base_info.dart';

class MessageVideoInfo extends MessageBaseInfo {
  String url;

  MessageVideoInfo({url});

  MessageVideoInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['url'] = url;
    return data;
  }
}
