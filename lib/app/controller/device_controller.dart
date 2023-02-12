import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/history.dart';
import 'package:speed_share/app/controller/utils/join_util.dart';
import 'package:speed_share/utils/http/http.dart';

class Device {
  Device(this.id);
  String? id;
  int? deviceType;
  String? deviceName;
  // url prefix
  String? url;
  int? messagePort;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Device) {
      return id == other.id;
    }
    return false;
  }

  static Color getColor(int? type) {
    switch (type) {
      case 0:
        return const Color(0xffED796A);
        break;
      case 1:
        return const Color(0xff6A6DED);
        break;
      case 2:
        return const Color(0xff317DEE);
        break;
      default:
        return Colors.indigo;
    }
  }

  Color get deviceColor {
    return getColor(deviceType);
  }

  @override
  String toString() {
    return 'id:$id deviceType:$deviceType deviceName:$deviceName address:$url';
  }
}

// 用于管理设备连接的类
class DeviceController extends GetxController {
  DeviceController() {
    if (GetPlatform.isWeb) {
      return;
    }
    // Log.i(RuntimeEnvir.filesPath);
    // Directory(RuntimeEnvir.filesPath).list().forEach((element) {
    //   Log.i(element);
    // });
    if (File(historyPath).existsSync()) {
      // 如果文件存在的话
      historys = Historys.fromJson(json.decode(File(historyPath).readAsStringSync()));
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(historys);
      Log.i(prettyprint);
      historys.datas!.removeWhere((element) => element.url!.contains('null'));
      // 向历史连接的设备发送连接消息
      Future.delayed(const Duration(milliseconds: 200), () {
        historys.datas!.forEach(
          ((element) {
            sendJoinEvent(element.url);
          }),
        );
      });
    } else {
      return;
    }
  }

  String historyPath = '${RuntimeEnvir.filesPath}/history';
  Historys historys = Historys(datas: []);
  List<Device> connectDevice = [];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void onDeviceConnect(
    String? id,
    String? name,
    int? type,
    String? urlPrefix,
    int? port,
  ) {
    Device device = Device(id)
      ..deviceType = type
      ..deviceName = name
      ..url = urlPrefix
      ..messagePort = port;
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(device);
    Log.i(prettyprint);
    if (!connectDevice.contains(device)) {
      // 第一次连接该设备
      connectDevice.add(device);
      if (!GetPlatform.isWeb) {
        appendHistory(name, '$urlPrefix:$port', id);
      }
      Log.i('device : $device');
    }
    update();
  }

  void appendHistory(String? name, String url, String? id) {
    History history = History(
      deviceName: name,
      url: url,
      id: id,
    );
    if (!historys.datas!.contains(history)) {
      // 不包含才
      historys.datas!.add(history);
      Log.i(historys);
    } else {
      History exist = historys.datas!.firstWhere((element) => element.id == history.id);
      exist.url = url;
    }
    syncHistoryToLocal();
  }

  void onDeviceClose(String? id) {
    connectDevice.remove(Device(id));
    update();
  }

  void syncHistoryToLocal() {
    File(historyPath).writeAsString(historys.toString());
  }

  void clear() {
    connectDevice.clear();
    update();
  }

  // void addHistory(String url) {
  //   historys.datas.add(History());
  //   history.add(url);
  //   'history'.set = jsonEncode(history);
  // }

  send(Map<String, dynamic> data) async {
    Set<String> urls = {};
    for (Device device in connectDevice) {
      // Log.i('${device.url}:${device.messagePort}');
      urls.add('${device.url}:${device.messagePort}');
    }
    // TODO之前下面三行代码是未注释的
    // for (String url in history) {
    //   urls.add(url);
    // }
    for (String url in urls) {
      // Log.i('$url');
      try {
        Response res = await httpInstance!.post(url, data: data);
      } catch (e) {
        // Log.e('send error : ${e}');
      }
    }
  }
}
