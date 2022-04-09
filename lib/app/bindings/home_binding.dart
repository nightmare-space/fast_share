import 'package:get/get.dart';
import 'package:speed_share/app/controller/controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingController());
    Get.put(OnlineController());
    Get.put(FileController());
    Get.put(DeviceController());
  }
}
