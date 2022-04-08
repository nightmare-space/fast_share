import 'dart:io';

import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';

class FileController extends GetxController {
  FileController();
  List<String> onknown = [];
  List<String> zipFiles = [];
  List<String> docFiles = [];
  List<String> audioFiles = [];
  List<FileSystemEntity> imgFiles = [];
  List<FileSystemEntity> dirFiles = [];
  List<FileSystemEntity> apkFiles = [];
  List<String> keys = [
    '未知',
    '压缩包',
    '文档',
    '音乐',
    '图片',
    '文件夹',
    '视频',
    '安装包',
  ];
  String prefix = '/sdcard/SpeedShare';
  @override
  void onInit() {
    super.onInit();
    Log.w('$this init');
    initFile();
  }

  void checkIfNotExist() {}
  Future<void> initFile() async {
    List<FileSystemEntity> list =
        await (Directory('/sdcard/SpeedShare/未知').list()).toList();
    for (var element in list) {
      onknown.add(basename(element.path));
    }
    List<FileSystemEntity> zip =
        await (Directory('/sdcard/SpeedShare/压缩包').list()).toList();
    for (var element in zip) {
      zipFiles.add(basename(element.path));
    }
    List<FileSystemEntity> doc =
        await (Directory('/sdcard/SpeedShare/文档').list()).toList();
    for (var element in doc) {
      docFiles.add(basename(element.path));
    }
    List<FileSystemEntity> audio =
        await (Directory('/sdcard/SpeedShare/音乐').list()).toList();
    for (var element in audio) {
      audioFiles.add(basename(element.path));
    }
    List<FileSystemEntity> img =
        await (Directory('/sdcard/SpeedShare/图片').list()).toList();
    for (var element in img) {
      imgFiles.add(element);
    }
    List<FileSystemEntity> dirs =
        await (Directory('/sdcard/SpeedShare/文件夹').list()).toList();
    for (var element in dirs) {
      dirFiles.add(element);
    }
    List<FileSystemEntity> apks =
        await (Directory('/sdcard/SpeedShare/安装包').list()).toList();
    for (var element in apks) {
      apkFiles.add(element);
    }
    update();
  }

  @override
  void onReady() {
    super.onReady();
    Log.w('$this onReady');
  }
}
