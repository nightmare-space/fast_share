import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/pages/dialog/join_chat_by_udp.dart';
import 'package:speed_share/utils/udp_util.dart';

import 'package:speed_share/utils/string_extension.dart';

class Global {
  factory Global() => _getInstance();
  Global._internal() {}
  String libPath = '';
  bool lockAdb = false;
  RawDatagramSocket socket;
  bool isInit = false;
  bool isStartSend = false;
  // 显示过弹窗的id会进这个列表
  List<String> hasShowDialogId = [];
  static Global get instance => _getInstance();
  static Global _instance;

  static Global _getInstance() {
    _instance ??= Global._internal();
    return _instance;
  }

  Future<void> _receiveBoardCast() async {
    RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      4545,
      reuseAddress: true,
      reusePort: false,
      ttl: 255,
    ).then((RawDatagramSocket socket) {
      socket.joinMulticast(Config.mDnsAddressIPv4);
      // 开启广播支持
      socket.broadcastEnabled = true;
      socket.readEventsEnabled = true;
      socket.listen((RawSocketEvent rawSocketEvent) async {
        final Datagram datagram = socket.receive();
        if (datagram == null) {
          return;
        }
        String message = String.fromCharCodes(datagram.data);
        Log.w(message);
        String id = message.split(' ').first;
        message = message.replaceAll(id, '').trim();
        if (!isStartSend && !hasShowDialogId.contains(id)) {
          hasShowDialogId.add(id);
          if (!GetPlatform.isWeb) {
            for (String serverAddr in message.split(' ')) {
              Log.v('消息带有的address -> ${serverAddr}');
              for (String localAddr in await PlatformUtil.localAddress()) {
                if (serverAddr.isSameSegment(localAddr)) {
                  Log.d('其中消息的 -> ${serverAddr} 与本地的$localAddr 在同一个局域网');
                  showDialog(
                    context: Get.context,
                    builder: (_) {
                      return JoinChatByUdp(
                        addr: serverAddr,
                      );
                    },
                  );
                }
              }
            }
          }
        }
      });
    });
  }

  Future<void> startSendBoardCast(String data) async {
    UniqueKey uniqueKey = UniqueKey();
    isStartSend = true;
    socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      0,
      ttl: 255,
    );
    socket.broadcastEnabled = true;
    socket.readEventsEnabled = true;
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    print('start ${stopwatch.elapsed}');
    while (true) {
      UdpUtil.boardcast(socket, uniqueKey.toString() + ' ' + data);
      if (!isStartSend) {
        break;
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Future<void> stopSendBoradcast() async {
    if (!isStartSend) {
      return;
    }
    isStartSend = false;
    socket.close();
  }

  Future<void> initGlobal() async {
    print('initGlobal');
    if (isInit) {
      return;
    }
    isInit = true;
    _receiveBoardCast();
  }
}
