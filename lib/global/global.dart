import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:multicast/multicast.dart';
import 'package:speed_share/app/controller/online_controller.dart';
import 'package:speed_share/app/controller/setting_controller.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/utils/shelf_static.dart';
import 'package:speed_share/utils/unique_util.dart';

/// 主要用来发现局域网的设备
class Global {
  factory Global() => _getInstance();
  Global._internal();
  static Global get instance => _getInstance();
  static Global _instance;
  static Global _getInstance() {
    _instance ??= Global._internal();
    return _instance;
  }

  Multicast multicast = Multicast();
  String localClipdata = '';
  String remoteClipdata = '';
  String deviceId = '';

  bool isInit = false;

  // /// 接收广播消息
  Future<void> _receiveUdpMessage(String message, String address) async {
    // Log.w(message);
    final String id = message.split(',').first;
    final String port = message.split(',').last;
    // if(message)
    // Log.e('UniqueUtil.getDevicesId() -> ${UniqueUtil.getDevicesId()}');

    if ((await PlatformUtil.localAddress()).contains(address)) {
      return;
    }
    if (id.startsWith('clip')) {
      SettingController settingController = Get.find();
      if (settingController.clipboardShare) {
        String data = id.replaceFirst(RegExp('^clip'), '');
        if (data != remoteClipdata && data != await getLocalClip()) {
          showToast('已复制剪切板');
          Log.i('已复制剪切板 ClipboardData ： $data');
          remoteClipdata = data;
          Clipboard.setData(ClipboardData(text: data));
        }
      }
    } else if (id.trim() != await UniqueUtil.getDevicesId()) {
      OnlineController onlineController = Get.find();
      onlineController.updateDevices(
        DeviceEntity(
          id,
          address,
          int.tryParse(port),
        ),
      );
    }
    // if (_showDialog && !hasShowDialogId.contains(id)) {
    //   // 需要将已经展示弹窗的id缓存，不然会一直弹窗
    //   hasShowDialogId.add(id);
    //   showDialog(
    //     context: Get.context,
    //     builder: (_) {
    //       return JoinChatByUdp(
    //         addr: address,
    //       );
    //     },
    //   );
    // }
  }

  Future<String> getLocalClip() async {
    ClipboardData clip = await Clipboard.getData(Clipboard.kTextPlain);
    return clip?.text ?? '';
  }

  void getclipboard() {
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      SettingController settingController = Get.find();
      if (!settingController.clipboardShare) {
        return;
      }
      ClipboardData clip = await Clipboard.getData(Clipboard.kTextPlain);
      if (clip != null && clip.text != localClipdata) {
        localClipdata = clip.text;
        Log.i('ClipboardData ： ${clip.text}');
        stopSendBoardcast();
        startSendBoardcast('clip' + clip.text);
        Future.delayed(const Duration(seconds: 3), () {
          stopSendBoardcast();
          boardcasdMessage.remove('clip' + clip.text);
          multicast.startSendBoardcast(boardcasdMessage);
        });
      }
    });
  }

  List<String> boardcasdMessage = [];
  Future<void> startSendBoardcast(String data) async {
    if (!boardcasdMessage.contains(data)) {
      boardcasdMessage.add(data);
    }
    multicast.startSendBoardcast(boardcasdMessage);
  }

  Future<void> stopSendBoardcast() async {
    multicast.stopSendBoardcast();
  }

  Future<void> initGlobal() async {
    Log.v('initGlobal');
    if (RuntimeEnvir.packageName != Config.packageName &&
        !GetPlatform.isDesktop) {
      // 如果这个项目是独立运行的，那么RuntimeEnvir.packageName会在main函数中被设置成Config.packageName
      // 这个 if 就不会走到，如果是被其他的项目依赖，RuntimeEnvir.packageName就会是对应的主仓库的包名
      Config.flutterPackage = 'packages/speed_share/';
    }
    deviceId = await UniqueUtil.getDevicesId();
    if (GetPlatform.isWeb || GetPlatform.isIOS) {
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
    }
    getclipboard();
    unpackWebResource();
  }

  /// 解压web资源
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
