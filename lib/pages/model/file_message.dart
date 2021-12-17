import 'base_message.dart';

class MessageFileInfo extends MessageBaseInfo {
  String fileName;
  String filePath;
  String fileSize;
  String url;

  MessageFileInfo({
    this.fileName,
    this.fileSize,
    this.url,
    this.filePath,
    String msgType = 'file',
    String type,
  }) : super(
          type: type,
          msgType: msgType,
        );

  MessageFileInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    fileName = json['fileName'];
    filePath = json['filePath'];
    fileSize = json['fileSize'];
    url = json['url'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['fileName'] = fileName;
    data['filePath'] = filePath;
    data['fileSize'] = fileSize;
    data['url'] = url;
    return data;
  }
}
