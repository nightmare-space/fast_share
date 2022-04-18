import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:speed_share/utils/ext_util.dart';
import 'package:speed_share/v2/preview_image.dart';
import 'package:speed_share/v2/video.dart';

class FileUtil {
  static void openFile(String path) {
    if (path.isImg) {
      Get.to(PreviewImage(
        path: path,
        tag: path,
      ));
    } else if (path.isVideo) {
      Get.to(
        SerieExample(
          url: path,
        ),
      );
    } else {
      OpenFile.open(path);
    }
  }
}
