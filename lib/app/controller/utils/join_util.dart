import 'package:get/get.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/model/model.dart';
import 'package:speed_share/utils/http/http.dart';

class JoinUtil {
  static void sendJoinEvent(
    List<String> addrs,
    int shelfBindPort,
    int chatBindPort,
    String url,
  ) {
    JoinMessage message = JoinMessage();
    message.deviceName = Global().deviceId;
    message.addrs = addrs;
    message.deviceType = type;
    message.filePort = shelfBindPort;
    message.messagePort = chatBindPort;
    httpInstance.post('$url/', data: message.toJson());
  }
}

List<String> _hasSendJoin = [];
Future<void> sendJoinEvent(String url) async {
  if (_hasSendJoin.contains(url)) {
    return;
  }
  ChatController controller = Get.find();
  await controller.getSuccessBindPort();
  JoinUtil.sendJoinEvent(
    controller.addrs,
    controller.shelfBindPort,
    controller.messageBindPort,
    url,
  );
  _hasSendJoin.add(url);
}
