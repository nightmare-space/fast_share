import 'message_base_info.dart';

class MessageVideoInfo extends MessageBaseInfo {
  String url;
  String thumbnailUrl;
  MessageVideoInfo({this.url, this.thumbnailUrl});

  MessageVideoInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    url = json['url'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['url'] = url;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }
}
