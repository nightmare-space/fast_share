import 'dart:io';

import 'package:path/path.dart';

// 获得一个安全保存的文件路径，入股偶已经有一个存在了，会在文件名后面添加一个别名
String getSafePath(String savePath) {
  if (!File(savePath).existsSync()) {
    return savePath;
  }
  String dirPath = dirname(savePath);
  String fileNameWithoutExt = basenameWithoutExtension(savePath);
  int count = 1;
  String newPath = '$dirPath/$fileNameWithoutExt($count)${extension(savePath)}';
  while (File(newPath).existsSync()) {
    count++;
    newPath = '$dirPath/$fileNameWithoutExt($count)${extension(savePath)}';
  }
  return newPath;
}
