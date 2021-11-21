import 'base_message.dart';

class BroswerFileMessage extends MessageBaseInfo {
  String fileName;
  String fileSize;

  BroswerFileMessage({
    this.fileName,
    this.fileSize,
    String msgType = 'webfile',
    String type,
  }) : super(
          type: type,
          msgType: msgType,
        );

  BroswerFileMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    fileName = json['fileName'];
    fileSize = json['fileSize'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['fileName'] = fileName;
    data['fileSize'] = fileSize;
    return data;
  }
}
