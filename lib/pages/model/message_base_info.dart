import 'dart:convert';

class MessageBaseInfo {
  String type;
  String data;
  String msgType;

  MessageBaseInfo({this.type, this.data, this.msgType});

  MessageBaseInfo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'];
    msgType = json['msgType'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['data'] = data;
    map['msgType'] = msgType;
    return map;
  }

  @override
  String toString() {
    return json.encode(this);
  }
}
