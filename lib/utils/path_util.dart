import 'dart:io';

import 'package:path/path.dart';

String getSafePath(String savePath) {
  if (!File(savePath).existsSync()) {
    return savePath;
  }
  String dirPath = dirname(savePath);
  String fileNameWithoutExt = basenameWithoutExtension(savePath);
  int count = 1;
  String newPath =
      dirPath + '/' + fileNameWithoutExt + '($count)' + extension(savePath);
  while (File(newPath).existsSync()) {
    count++;
    newPath =
        dirPath + '/' + fileNameWithoutExt + '($count)' + extension(savePath);
  }
  return newPath;
}
