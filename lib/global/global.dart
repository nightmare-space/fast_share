import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/utils.dart';
import 'package:global_repository/global_repository.dart';
import 'package:multicast/multicast.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/pages/dialog/join_chat_by_udp.dart';
import 'package:speed_share/utils/shelf_static.dart';
import 'package:speed_share/utils/string_extension.dart';

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
  Future<void> _receiveUdpMessage(String message, _) async {
    // Log.w(message);
    String id = message.split(' ').first;
    message = message.replaceAll(id, '').trim();
    if (_showDialog && !hasShowDialogId.contains(id)) {
      hasShowDialogId.add(id);
      for (String serverAddr in message.split(' ')) {
        Log.v('消息带有的address -> ${serverAddr}');
        for (String localAddr in await PlatformUtil.localAddress()) {
          if (serverAddr.hasThreePartEqual(localAddr)) {
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

  void enableShowDialog() {
    _showDialog = true;
  }

  void disableShowDialog() {
    _showDialog = false;
  }

  Future<void> startSendBoardcast(String data) async {
    multicast.startSendBoardcast(data);
  }

  Future<void> stopSendBoradcast() async {
    multicast.stopSendBoardcast();
  }

  Future<void> initGlobal() async {
    print('initGlobal');
    if (GetPlatform.isWeb) {
      // web udp 和部署都不支持
      return;
    }
    if (isInit) {
      return;
    }
    isInit = true;
    multicast.addListener(_receiveUdpMessage);
    if (GetPlatform.isAndroid || GetPlatform.isDesktop) {
      // 开启静态部署，类似于 nginx 和 tomcat
      ShelfStatic.start();
      // ServerUtil.start();
    }
    unpackWebResource();
  }

  Future<void> unpackWebResource() async {
    ByteData byteData = await rootBundle.load(
      '${Config.flutterPackage}assets/web.zip',
    );
    final Uint8List list = byteData.buffer.asUint8List();
    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(list);
    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File wfile = File(RuntimeEnvir.filesPath + '/' + filename);
        await wfile.create(recursive: true);
        await wfile.writeAsBytes(data);
      } else {
        await Directory(RuntimeEnvir.filesPath + '/' + filename).create(
          recursive: true,
        );
      }
    }
  }
}
