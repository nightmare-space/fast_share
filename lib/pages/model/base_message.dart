import 'dart:convert';

class MessageBaseInfo {
  String type;
  String data;
  String msgType;
  String sendFrom;

  MessageBaseInfo({
    this.type,
    this.data,
    this.msgType,
    this.sendFrom = '',
  });

  MessageBaseInfo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'];
    msgType = json['msgType'];
    sendFrom = json['sendFrom'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['data'] = data;
    map['msgType'] = msgType;
    map['sendFrom'] = sendFrom;
    return map;
  }

  @override
  String toString() {
    return json.encode(this);
  }
}
