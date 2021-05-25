import 'dart:convert';

class MessageBaseInfo {
  String type;
  String data;
  String msgType;
  List<dynamic> address;

  MessageBaseInfo({this.type, this.data, this.msgType, this.address});

  MessageBaseInfo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'];
    msgType = json['msgType'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['data'] = data;
    map['msgType'] = msgType;
    map['address'] = address;
    return map;
  }

  @override
  String toString() {
    return json.encode(this);
  }
}
