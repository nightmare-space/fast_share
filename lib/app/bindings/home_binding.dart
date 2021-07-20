import 'package:get/get.dart';
import 'package:speed_share/app/controller/setting_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingController());
  }
}
