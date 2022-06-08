import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:file_selector_nightmare/file_selector_nightmare.dart';
import 'package:get/get.dart';

// 用来选择文件的
Future<List<XFile>> getFilesForDesktopAndWeb() async {
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

Future<List<String>> getFilesPathsForAndroid(bool useSystemPicker) async {
  // 选择文件路径
  List<String> filePaths = [];
  if (!useSystemPicker) {
    filePaths = await FileSelector.pick(
      Get.context,
    );
  } else {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowCompression: false,
      allowMultiple: true,
    );
    if (result != null) {
      for (PlatformFile file in result.files) {
        filePaths.add(file.path);
      }
    } else {
      // User canceled the picker
    }
  }
  filePaths ??= [];
  return filePaths;
}
