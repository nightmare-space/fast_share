import 'base_message.dart';

class BroswerFileMessage extends MessageBaseInfo {
  String? fileName;
  String? fileSize;
  String? hash;
  String? blob;

  BroswerFileMessage({
    this.fileName,
    this.fileSize,
    this.hash,
    this.blob,
    String msgType = 'webfile',
    String? deviceName,
  }) : super(
          msgType: msgType,
          deviceName: deviceName,
        );

  BroswerFileMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    hash = json['hash'];
    blob = json['blob'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['fileName'] = fileName;
    data['fileSize'] = fileSize;
    data['hash'] = hash;
    data['blob'] = blob;
    return data;
  }
}
