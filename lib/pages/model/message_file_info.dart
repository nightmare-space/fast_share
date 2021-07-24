import 'message_base_info.dart';

class MessageFileInfo extends MessageBaseInfo {
  String fileName;
  String filePath;
  String fileSize;
  String url;

  MessageFileInfo({
    this.fileName,
    this.fileSize,
    this.url,
    String msgType,
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
        );

  MessageFileInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    fileName = json['fileName'];
    filePath = json['filePath'];
    fileSize = json['fileSize'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['fileName'] = fileName;
    data['filePath'] = filePath;
    data['fileSize'] = fileSize;
    data['url'] = url;
    return data;
  }
}

class MessageImgInfo extends MessageFileInfo {
  MessageImgInfo({
    String msgType,
    String type,
    String data,
  }) : super(
          data: data,
          type: type,
          msgType: msgType,
        );

  MessageImgInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {}

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    return data;
  }
}

class MessageVideoInfo extends MessageFileInfo {
  MessageVideoInfo();

  MessageVideoInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {}

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    return data;
  }
}
