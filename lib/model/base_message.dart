import 'dart:convert';

class MessageBaseInfo {
  String? msgType;
  String? deviceName;
  // 用来做发送设备的位移标识
  String? deviceId;
  int? deviceType;

  MessageBaseInfo({
    this.msgType,
    this.deviceName = '',
    this.deviceType,
    this.deviceId,
  });

  MessageBaseInfo.fromJson(Map<String, dynamic> json) {
    msgType = json['msgType'];
    deviceName = json['deviceName'];
    deviceType = json['deviceType'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgType'] = msgType;
    map['deviceName'] = deviceName;
    map['deviceType'] = deviceType;
    map['deviceId'] = deviceId;
    return map;
  }

  @override
  String toString() {
    return json.encode(this);
  }
}
