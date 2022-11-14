import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:signale/signale.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/model/model.dart';
import 'package:speed_share/utils/http/http.dart';

class JoinUtil {
  static Future<bool> sendJoinEvent(
    List<String> addrs,
    int shelfBindPort,
    int chatBindPort,
    String url,
  ) async {
    JoinMessage message = JoinMessage();
    message.deviceName = Global().deviceName;
    message.deviceId = Global().uniqueKey;
    message.addrs = addrs;
    message.deviceType = type;
    message.filePort = shelfBindPort;
    message.messagePort = chatBindPort;
    Log.i(message);
    try {
      Response res = await httpInstance.post(
        '$url/',
        data: message.toJson(),
      );
      Log.i('sendJoinEvent result : ${res.data}');
      return true;
      // deviceController.onDeviceConnect(res.data, name, type, urlPrefix, port)
    } on DioError catch (e) {
      Log.e('$url 发送加入消息异常，但不一定会影响使用\n详情：${e.message}');
      return false;
    }
  }
}

List<String> _hasSendJoin = [];
Future<void> sendJoinEvent(String url) async {
  // Log.i('sendJoinEvent : $url');
  // Log.i('_hasSendJoin : $_hasSendJoin');
  if (_hasSendJoin.contains(url)) {
    return;
  }
  Log.i('sendJoinEvent : $url');
  ChatController controller = Get.find();
  await controller.initLock.future;
  // 成功发送消息才加入已发送堆栈
  bool success = await JoinUtil.sendJoinEvent(
    controller.addrs,
    controller.shelfBindPort,
    controller.messageBindPort,
    url,
  );
  if (success) {
    _hasSendJoin.add(url);
    Log.i('sendJoinEvent : $url Success');
  }
}
