import 'base_message.dart';
import 'notify_message.dart';

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

  List<String> addrs;
  int port;

  JoinMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final List<String> addrs = json['addrs'] is List ? <String>[] : null;
    if (addrs != null) {
      for (final dynamic item in json['addrs']) {
        if (item != null) {
          addrs.add(asT<String>(item));
        }
      }
    }
    this.addrs = addrs;
    port = asT<int>(json['port']);
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['addrs'] = addrs;
    data['port'] = port;
    return data;
  }
}
