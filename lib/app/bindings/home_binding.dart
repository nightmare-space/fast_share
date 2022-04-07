import 'package:get/get.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/file_controller.dart';
import 'package:speed_share/app/controller/online_controller.dart';
import 'package:speed_share/app/controller/setting_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingController());
    Get.put(OnlineController());
    Get.put(FileController());
  }
}
