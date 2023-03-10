import 'dart:async';
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
  bool? isConnect;

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
      case 1:
        return const Color(0xff6A6DED);
      case 2:
        return const Color(0xff317DEE);
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
      Log.i('history cache $prettyprint');
      historys.datas!.removeWhere((element) => element.url!.contains('null'));
      syncHistoryToLocal();
      List<History> newHistorys = [];
      // for (History history in historys.datas!) {
      //   History exist=newHistorys.firstWhere((element) => element.url=)
      // }
      // 向历史连接的设备发送连接消息
      Future.delayed(const Duration(milliseconds: 200), () {
        historys.datas!.forEach(
          ((element) {
            // TODO
            sendJoinEvent(element.url!);
          }),
        );
      });
    } else {
      return;
    }
    checkConnectStat();
    // TODO 开启定时器
    // 检测链接设备是否互通
  }

  void checkConnectStat() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      for (Device device in connectDevice) {
        try {
          Response response = await Dio().get('${device.url}:${device.messagePort}/check_token');
          // Log.d(response.data);
          device.isConnect = true;
          update();
        } catch (e) {
          device.isConnect = false;
          update();
        }
      }
    });
  }

  String historyPath = '${RuntimeEnvir.filesPath}/history';
  Historys historys = Historys(datas: []);
  List<Device> connectDevice = [];
  int availableDevice() {
    int count = 0;
    for (Device device in connectDevice) {
      if (device.isConnect ?? false) {
        count++;
      }
    }
    return count;
  }

  /// 返回正常连接的设备
  List<Device> availableDevices() {
    List<Device> devices = [];
    for (Device device in connectDevice) {
      if (device.isConnect ?? false) {
        devices.add(device);
      }
    }
    return devices;
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
      ..isConnect = true
      ..messagePort = port;
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
      // 不包含才添加这行历史
      historys.datas!.add(history);
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
        await httpInstance!.post(url, data: data);
      } catch (e) {
        // Log.e('send error : ${e}');
      }
    }
  }

  /// 判断一个IP是否已经被连接了
  /// 发送连接消息的时候需要的
  bool ipIsConnect(String ip) {
    Uri? ipUrl = Uri.tryParse(ip);
    for (Device device in availableDevices()) {
      Uri? uri = Uri.tryParse(device.url!);
      if (uri?.host == ipUrl?.host) {
        return true;
      }
    }
    return false;
  }

  /// 清除历史
  void clearHistory() {
    historys.datas?.clear();
    update();
    syncHistoryToLocal();
  }
}
