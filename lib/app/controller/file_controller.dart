import 'dart:io';

import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';

class FileController extends GetxController {
  FileController() {
    if (GetPlatform.isWindows) {
      prefix = FileSystemEntity.parentOf(Platform.resolvedExecutable);
    }
  }
  List<FileSystemEntity> onknown = [];
  List<FileSystemEntity> zipFiles = [];
  List<FileSystemEntity> docFiles = [];
  List<FileSystemEntity> audioFiles = [];
  List<FileSystemEntity> imgFiles = [];
  List<FileSystemEntity> dirFiles = [];
  List<FileSystemEntity> apkFiles = [];
  List<FileSystemEntity> videoFiles = [];
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

  void checkIfNotExist() {
    for (var key in keys) {
      Directory dir = Directory(prefix + '/' + key);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
    }
  }

  List<FileSystemEntity> getRecent() {
    List<FileSystemEntity> all = [];
    all.addAll(onknown);
    all.addAll(zipFiles);
    all.addAll(docFiles);
    all.addAll(audioFiles);
    all.addAll(imgFiles);
    all.addAll(dirFiles);
    all.addAll(apkFiles);
    all.addAll(videoFiles);
    all.removeWhere((element) => element is Directory);
    all.sort((a, b) {
      return (b as File)
          .lastModifiedSync()
          .compareTo((a as File).lastModifiedSync());
    });
    return all;
  }

  Future<void> initFile() async {
    checkIfNotExist();
    List<FileSystemEntity> list =
        await (Directory('$prefix/未知').list()).toList();
    for (var element in list) {
      onknown.add(element);
    }
    List<FileSystemEntity> zip =
        await (Directory('$prefix/压缩包').list()).toList();
    for (var element in zip) {
      zipFiles.add(element);
    }
    List<FileSystemEntity> doc =
        await (Directory('$prefix/文档').list()).toList();
    for (var element in doc) {
      docFiles.add(element);
    }
    List<FileSystemEntity> audio =
        await Directory('$prefix/音乐').list().toList();
    for (var element in audio) {
      audioFiles.add(element);
    }
    List<FileSystemEntity> img =
        await (Directory('$prefix/图片').list()).toList();
    for (var element in img) {
      imgFiles.add(element);
    }
    List<FileSystemEntity> dirs =
        await (Directory('$prefix/文件夹').list()).toList();
    for (var element in dirs) {
      dirFiles.add(element);
    }
    List<FileSystemEntity> apks =
        await (Directory('$prefix/安装包').list()).toList();
    for (var element in apks) {
      apkFiles.add(element);
    }
    List<FileSystemEntity> video =
        await (Directory('$prefix/视频').list()).toList();
    for (var element in video) {
      videoFiles.add(element);
    }
    update();
  }

  @override
  void onReady() {
    super.onReady();
    Log.w('$this onReady');
  }
}
