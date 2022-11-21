import 'model.dart';

class DirMessage extends MessageBaseInfo {
  String dirName;
  int fullSize;
  bool canDownload = false;
  List<String> paths = [];
  String urlPrifix;
  List<String> addrs;
  String url;
  int port;

  DirMessage({
    this.dirName,
    this.fullSize,
    this.canDownload,
    this.paths,
    this.urlPrifix,
    String deviceName,
    this.addrs,
    this.port,
  }) : super(
          msgType: 'dir',
          deviceName: deviceName,
        );

  DirMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    dirName = json['dirName'];
    fullSize = json['fullSize'];
    urlPrifix = json['urlPrifix'];
    canDownload = json['canDownload'] ?? false;
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
    data['dirName'] = dirName;
    data['fullSize'] = fullSize;
    data['canDownload'] = canDownload;
    data['urlPrifix'] = urlPrifix;
    data['port'] = port;
    data['addrs'] = addrs;
    return data;
  }
}

class DirPartMessage extends MessageBaseInfo {
  String path;
  String stat;
  String partOf;
  int size;
  DirPartMessage({
    this.path,
    this.size,
    this.partOf,
  }) : super(
          msgType: 'dirPart',
        );

  DirPartMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    path = json['path'];
    stat = json['stat'];
    partOf = json['partOf'];
    size = json['size'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['path'] = path;
    data['stat'] = stat;
    data['partOf'] = partOf;
    data['size'] = size;
    return data;
  }
}
