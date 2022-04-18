import 'dart:convert';

class MessageBaseInfo {
  String type;
  String data;
  String msgType;
  String sendFrom;
  // 用来做发送设备的位移标识
  String sendId;
  int deviceType;

  MessageBaseInfo({
    this.type,
    this.data,
    this.msgType,
    this.sendFrom = '',
    this.deviceType,
    this.sendId,
  });

  MessageBaseInfo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'];
    msgType = json['msgType'];
    sendFrom = json['sendFrom'];
    deviceType = json['deviceType'];
    sendId = json['sendId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['data'] = data;
    map['msgType'] = msgType;
    map['sendFrom'] = sendFrom;
    map['deviceType'] = deviceType;
    map['sendId'] = sendId;
    return map;
  }

  @override
  String toString() {
    return json.encode(this);
  }
}
