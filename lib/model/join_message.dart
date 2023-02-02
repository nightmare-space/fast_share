import 'base_message.dart';
import 'notify_message.dart';

class JoinMessage extends MessageBaseInfo {
  JoinMessage({
    String msgType = 'join',
  }) : super(
          msgType: msgType,
        );

  List<String?>? addrs;
  int? messagePort;
  int? filePort;

  JoinMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final List<String?>? addrs = json['addrs'] is List ? <String?>[] : null;
    if (addrs != null) {
      for (final dynamic item in json['addrs']) {
        if (item != null) {
          addrs.add(asT<String>(item));
        }
      }
    }
    this.addrs = addrs;
    messagePort = asT<int>(json['message_port']);
    filePort = asT<int>(json['file_port']);
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['addrs'] = addrs;
    data['message_port'] = messagePort;
    data['file_port'] = filePort;
    return data;
  }
}
