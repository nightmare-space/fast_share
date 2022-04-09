import 'base_message.dart';

class JoinMessage extends MessageBaseInfo {
  String deviceId;

  JoinMessage({
    this.deviceId,
    String msgType,
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
        );

  JoinMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    deviceId = json['device_id'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['devic_id'] = deviceId;
    return data;
  }
}
