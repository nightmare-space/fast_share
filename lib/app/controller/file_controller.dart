import 'dart:io';

import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';
import 'package:speed_share/v2/ext_util.dart';

const onknownKey = '未知';
const zipKey = '压缩包';
const docKey = '文档';
const audioKey = '音乐';
const picKey = '图片';
const dirKey = '文件夹';
const videoKey = '视频';
const apkKey = '安装包';

class FileController extends GetxController {
  FileController() {
    if (GetPlatform.isWindows) {
      prefix = FileSystemEntity.parentOf(Platform.resolvedExecutable) +
          '/SpeedShare';
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
    onknownKey,
    zipKey,
    docKey,
    audioKey,
    picKey,
    dirKey,
    videoKey,
    apkKey,
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

  FileSystemEntity getRecentImage() {
    List<FileSystemEntity> tmp = [];
    tmp.addAll(imgFiles);
    tmp.sort((a, b) {
      return (b as File)
          .lastModifiedSync()
          .compareTo((a as File).lastModifiedSync());
    });
    return tmp.isEmpty ? null : tmp.first;
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
    moveFile();
    List<FileSystemEntity> list =
        await (Directory('$prefix/$onknownKey').list()).toList();
    for (var element in list) {
      onknown.add(element);
    }
    List<FileSystemEntity> zip =
        await (Directory('$prefix/$zipKey').list()).toList();
    for (var element in zip) {
      zipFiles.add(element);
    }
    List<FileSystemEntity> doc =
        await (Directory('$prefix/$docKey').list()).toList();
    for (var element in doc) {
      docFiles.add(element);
    }
    List<FileSystemEntity> audio =
        await Directory('$prefix/$audioKey').list().toList();
    for (var element in audio) {
      audioFiles.add(element);
    }
    List<FileSystemEntity> img =
        await (Directory('$prefix/$picKey').list()).toList();
    for (var element in img) {
      imgFiles.add(element);
    }
    List<FileSystemEntity> dirs =
        await (Directory('$prefix/$dirKey').list()).toList();
    for (var element in dirs) {
      dirFiles.add(element);
    }
    List<FileSystemEntity> apks =
        await (Directory('$prefix/$apkKey').list()).toList();
    for (var element in apks) {
      apkFiles.add(element);
    }
    List<FileSystemEntity> video =
        await (Directory('$prefix/$videoKey').list()).toList();
    for (var element in video) {
      videoFiles.add(element);
    }
    update();
  }

  Future<File> moveFileSafe(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  void moveFile() async {
    List<FileSystemEntity> video = await (Directory('$prefix').list()).toList();
    for (var element in video) {
      String path = element.path;
      if (element is File) {
        if (path.isVideo) {
          moveFileSafe(
              element, prefix + '/$videoKey/' + basename(element.path));
        } else if (path.isDoc) {
          moveFileSafe(element, prefix + '/$docKey/' + basename(element.path));
        } else if (path.isAudio) {
          moveFileSafe(
              element, prefix + '/$audioKey/' + basename(element.path));
        } else if (path.isApk) {
          moveFileSafe(element, prefix + '/$apkKey/' + basename(element.path));
        } else if (path.isImg) {
          moveFileSafe(element, prefix + '/$picKey/' + basename(element.path));
        } else if (path.isZip) {
          moveFileSafe(element, prefix + '/$zipKey/' + basename(element.path));
        } else {
          moveFileSafe(
              element, prefix + '/$onknownKey/' + basename(element.path));
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    Log.w('$this onReady');
  }
}
