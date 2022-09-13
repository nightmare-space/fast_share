import 'base_message.dart';

class DirMessage extends MessageBaseInfo {
  String dirName;
  int fullSize;
  bool canDownload = false;
  List<String> paths = [];
  String urlPrifix;

  DirMessage({
    this.dirName,
    this.fullSize,
    this.canDownload,
    this.paths,
    this.urlPrifix,
    String msgType,
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
        );

  DirMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    dirName = json['dirName'];
    fullSize = json['fullSize'];
    urlPrifix = json['urlPrifix'];
    canDownload = json['canDownload'] ?? false;
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['dirName'] = dirName;
    data['fullSize'] = fullSize;
    data['canDownload'] = canDownload;
    data['urlPrifix'] = urlPrifix;
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
    String msgType,
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
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
