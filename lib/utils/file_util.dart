import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:speed_share/modules/preview/image_preview.dart';
import 'package:speed_share/modules/preview/video_preview.dart';
import 'package:speed_share/utils/ext_util.dart';

class FileUtil {
  static void openFile(String path) {
    if (path.isImg) {
      Get.to(
        () => PreviewImage(
          path: path,
          tag: path,
        ),
      );
    } else if (path.isVideo) {
      Get.to(
        () => VideoPreview(
          url: path,
        ),
      );
    } else {
      OpenFile.open(path);
    }
  }

  // 获得windows的盘符列表
  // google查下
  // 尽量用ffi调用win32 api
  static List<String> getWindowsDrive() {
    //TODO(ren)
  }
}
