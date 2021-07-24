import 'message_base_info.dart';

class MessageDirInfo extends MessageBaseInfo {
  String dirName;
  int fullSize;
  bool canDownload = false;
  List<String> paths = [];
  String urlPrifix;

  MessageDirInfo({
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

  MessageDirInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    dirName = json['dirName'];
    fullSize = json['fullSize'];
    urlPrifix = json['urlPrifix'];
    canDownload = json['canDownload'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['dirName'] = dirName;
    data['fullSize'] = fullSize;
    data['canDownload'] = canDownload;
    data['urlPrifix'] = urlPrifix;
    return data;
  }
}

class MessageDirPartInfo extends MessageBaseInfo {
  String path;
  String stat;
  String partOf;
  int size;
  MessageDirPartInfo({
    this.path,
    String msgType,
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
        );

  MessageDirPartInfo.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    path = json['path'];
    stat = json['stat'];
    partOf = json['partOf'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['path'] = path;
    data['stat'] = stat;
    data['partOf'] = partOf;
    data['size'] = size;
    return data;
  }
}
