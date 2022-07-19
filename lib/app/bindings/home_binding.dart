import 'package:get/get.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/app/controller/download_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingController());
    Get.put(FileController());
    Get.put(DownloadController());
  }
}
