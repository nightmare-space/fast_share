import 'package:global_repository/global_repository.dart';

import 'base_message.dart';

class NotifyMessage extends MessageBaseInfo {
  String hash;
  List<String> addrs;
  int port;

  NotifyMessage({
    this.hash,
    this.addrs,
    this.port,
    String msgType = 'notify',
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
        );

  NotifyMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    Log.w("json['addrs'] -> ${json['addrs'].runtimeType}");
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
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['hash'] = hash;
    data['port'] = port;
    data['addrs'] = addrs;
    return data;
  }
}

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}
