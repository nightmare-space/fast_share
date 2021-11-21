import 'package:global_repository/global_repository.dart';

import 'base_message.dart';

class NotifyMessage extends MessageBaseInfo {
  String des;
  String name;
  List<String> urls;
  int port;

  NotifyMessage({
    this.des,
    this.name,
    this.urls,
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
    Log.w("json['urls'] -> ${json['urls'].runtimeType}");
    final List<String> urls = json['urls'] is List ? <String>[] : null;
    if (urls != null) {
      for (final dynamic item in json['urls']) {
        if (item != null) {
          urls.add(asT<String>(item));
        }
      }
    }
    this.urls = urls;
    port = asT<int>(json['port']);
    des = json['des'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['des'] = des;
    data['name'] = name;
    data['port'] = port;
    data['urls'] = urls;
    return data;
  }
}

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}
