import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:signale/signale.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/model/model.dart';
import 'package:speed_share/utils/http/http.dart';

class JoinUtil {
  // todo增加发送加入消息是否成功的结果
  static Future<void> sendJoinEvent(
    List<String> addrs,
    int shelfBindPort,
    int chatBindPort,
    String url,
  ) async {
    JoinMessage message = JoinMessage();
    message.deviceName = Global().deviceId;
    message.addrs = addrs;
    message.deviceType = type;
    message.filePort = shelfBindPort;
    message.messagePort = chatBindPort;
    try {
      Response res = await httpInstance.post(
        '$url/',
        data: message.toJson(),
      );
      Log.i('sendJoinEvent result : ${res.data}');
      // todo 这儿就应该添加设备
    } on DioError catch (e) {
      Log.e('$url 发送加入消息异常，但不一定会影响使用\n详情：${e.message}');
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
  // TODO成功后才添加已经发送列表
  _hasSendJoin.add(url);
  Log.i('sendJoinEvent : $url');
  ChatController controller = Get.find();
  await controller.initLock.future;
  JoinUtil.sendJoinEvent(
    controller.addrs,
    controller.shelfBindPort,
    controller.messageBindPort,
    url,
  );
}
