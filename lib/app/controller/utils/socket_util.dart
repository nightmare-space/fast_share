import 'dart:async';

import 'package:get/get_connect.dart';
import 'package:global_repository/global_repository.dart';

class SocketUtil {
  static Future<bool> connect(GetSocket socket) async {
    Completer conLock = Completer();
    socket.onOpen(() {
      Log.d('chat连接成功');
      if (!conLock.isCompleted) {
        conLock.complete(true);
      }
    });
    try {
      socket.connect();
      Future.delayed(const Duration(seconds: 2), () {
        // 可能onopen标记完成了
        if (!conLock.isCompleted) {
          conLock.complete(true);
        }
      });
    } catch (e) {
      conLock.complete(false);
    }
    return await conLock.future;
  }
}
