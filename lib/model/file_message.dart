import 'base_message.dart';
import 'notify_message.dart';

class FileMessage extends MessageBaseInfo {
  String? fileName;
  String? filePath;
  String? fileSize;
  List<String?>? addrs;
  String? url;
  int? port;

  FileMessage({
    this.fileName,
    this.fileSize,
    this.port,
    this.addrs,
    this.filePath,
    String msgType = 'file',
    String? sendFrom,
  }) : super(
          msgType: msgType,
          deviceName: sendFrom,
        );

  FileMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    fileName = json['fileName'];
    filePath = json['filePath'];
    fileSize = json['fileSize'];
    final List<String?>? addrs = json['addrs'] is List ? <String?>[] : null;
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
    data['fileName'] = fileName;
    data['filePath'] = filePath;
    data['fileSize'] = fileSize;
    data['port'] = port;
    data['addrs'] = addrs;
    return data;
  }
}
