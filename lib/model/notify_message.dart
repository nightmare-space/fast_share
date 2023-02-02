import 'base_message.dart';

class NotifyMessage extends MessageBaseInfo {
  String? hash;
  List<String?>? addrs;
  int? port;

  NotifyMessage({
    this.hash,
    this.addrs,
    this.port,
    String msgType = 'notify',
  }) : super(
          msgType: msgType,
        );

  NotifyMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final List<String?>? addrs = json['addrs'] is List ? <String?>[] : null;
    if (addrs != null) {
      for (final dynamic item in json['addrs']) {
        if (item != null) {
          addrs.add(asT<String>(item));
        }
      }
    }
    this.addrs = addrs;
    port = asT<int>(json['port']);
    hash = json['hash'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['hash'] = hash;
    data['port'] = port;
    data['addrs'] = addrs;
    return data;
  }
}

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}
