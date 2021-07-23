import 'package:get/get.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/setting_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController());
  }
}
