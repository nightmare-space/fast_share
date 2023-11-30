import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:get/get.dart';
import 'package:file_manager_view/file_manager_view.dart' as file_manager;

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
    filePaths = (await file_manager.FileSelector.pick(
      Get.context!,
    ));
  } else {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: false,
      allowMultiple: true,
    );
    if (result != null) {
      for (PlatformFile file in result.files) {
        filePaths.add(file.path!);
      }
    } else {
      // User canceled the picker
    }
  }
  return filePaths;
}
