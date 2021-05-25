import 'message_base_info.dart';

class MessageImgInfo extends MessageBaseInfo {
  String url;

  MessageImgInfo({
    this.url,
    String msgType,
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
        );

  MessageImgInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['url'] = url;
    return data;
  }
}
