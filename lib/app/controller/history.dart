import 'dart:convert';

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class Historys {
  Historys({
    this.datas,
  });

  factory Historys.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    final List<History> datas = json['datas'] is List ? <History>[] : null;
    if (datas != null) {
      for (final dynamic item in json['datas']) {
        if (item != null) {
          datas.add(History.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }
    return Historys(
      datas: datas,
    );
  }

  List<History> datas;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'datas': datas,
      };
}

class History {
  History({
    this.id,
    this.url,
    this.deviceName,
  });

  factory History.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : History(
          id: asT<String>(json['id']),
          url: asT<String>(json['url']),
          deviceName: asT<String>(json['device_name']),
        );

  String id;
  String url;
  String deviceName;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'url': url,
        'device_name': deviceName,
      };

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is History) {
      return id == other.id;
    }
    return false;
  }
}
