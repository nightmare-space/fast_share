import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/pages/dialog/join_chat_by_udp.dart';
import 'package:speed_share/utils/multicast/multicast.dart';
import 'package:speed_share/utils/utils.dart';

/// 主要用来发现局域网的设备
class Global {
  factory Global() => _getInstance();
  Global._internal() {}
  static Global get instance => _getInstance();
  static Global _instance;
  static Global _getInstance() {
    _instance ??= Global._internal();
    return _instance;
  }

  Multicast multicast = Multicast();

  bool isInit = false;
  // 是否显示其他设备创建房间后的弹窗
  bool _showDialog = true;
  // 显示过弹窗的id会进这个列表
  List<String> hasShowDialogId = [];
  // /// 接收广播消息
  Future<void> _receiveUdpMessage(String message) async {
    Log.w(message);
    String id = message.split(' ').first;
    message = message.replaceAll(id, '').trim();
    if (_showDialog && !hasShowDialogId.contains(id)) {
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
  }

  void enableShowDialog() {
    _showDialog = true;
  }

  void disableShowDialog() {
    _showDialog = false;
  }

  Future<void> startSendBoardCast(String data) async {
    multicast.startSendBoardCast(data);
  }

  Future<void> stopSendBoradcast() async {
    multicast.stopSendBoardCast();
  }

  Future<void> initGlobal() async {
    print('initGlobal');
    if (isInit) {
      return;
    }
    isInit = true;

    multicast.addListener(_receiveUdpMessage);
    multicast.addListener((data) {});
  }
}
