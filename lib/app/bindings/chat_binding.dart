import 'package:get/get.dart';
import 'package:speed_share/app/controller/chat_controller.dart';

// Getx 相关的类
class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController());
  }
}
