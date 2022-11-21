import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/config/config.dart';

/// 解压web资源
Future<void> unpackWebResource() async {
  ByteData byteData = await rootBundle.load(
    '${Config.flutterPackage}assets/web.zip',
  );
  final Uint8List list = byteData.buffer.asUint8List();
  // Decode the Zip file
  final archive = ZipDecoder().decodeBytes(list);
  // Extract the contents of the Zip archive to disk.
  for (final file in archive) {
    final filename = file.name;
    if (file.isFile) {
      final data = file.content as List<int>;
      File wfile = File('${RuntimeEnvir.filesPath}/$filename');
      await wfile.create(recursive: true);
      await wfile.writeAsBytes(data);
    } else {
      await Directory('${RuntimeEnvir.filesPath}/$filename').create(
        recursive: true,
      );
    }
  }
}
