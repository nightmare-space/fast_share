import 'base_message.dart';

class JoinMessage extends MessageBaseInfo {
  JoinMessage({
    String msgType = 'join',
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
        );

  JoinMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {}

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    return data;
  }
}
