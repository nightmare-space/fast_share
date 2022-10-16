import 'base_message.dart';

class BroswerFileMessage extends MessageBaseInfo {
  String fileName;
  String fileSize;
  String hash;

  BroswerFileMessage({
    this.fileName,
    this.fileSize,
    this.hash,
    String msgType = 'webfile',
    String type,
    String deviceName,
  }) : super(
          type: type,
          msgType: msgType,
          deviceName: deviceName,
        );

  BroswerFileMessage.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    hash = json['hash'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['fileName'] = fileName;
    data['fileSize'] = fileSize;
    data['hash'] = hash;
    return data;
  }
}
