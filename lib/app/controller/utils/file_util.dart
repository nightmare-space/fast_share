import 'package:file_manager/file_manager.dart';
import 'package:file_selector/file_selector.dart';
import 'package:get/get.dart';

// 用来选择文件的
Future<List<XFile>?> getFilesForDesktopAndWeb() async {
  final typeGroup = XTypeGroup(
    label: 'images',
    extensions: GetPlatform.isWeb ? [''] : null,
  );
  final files = await openFiles(acceptedTypeGroups: [typeGroup]);
  if (files.isEmpty) {
    return null;
  }
  return files;
}

/// 选择文件路径
Future<List<String?>> getFilesPathsForAndroid(bool useSystemPicker) async {
  List<String> filePaths = [];
  if (!useSystemPicker) {
    filePaths = await FileManager.selectFile();
  } else {
    // const XTypeGroup jpgsTypeGroup = XTypeGroup(
    //   label: 'JPEGs',
    //   extensions: <String>['jpg', 'jpeg'],
    // );
    // const XTypeGroup pngTypeGroup = XTypeGroup(
    //   label: 'PNGs',
    //   extensions: <String>['png'],
    // );
    final List<XFile> files = await openFiles();
    return files.map((e) => e.path).toList();
  }
  return filePaths;
}
