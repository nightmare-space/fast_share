import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:settings/settings.dart';
import 'package:speed_share/app/controller/utils/join_util.dart';
import 'package:speed_share/utils/http/http.dart';

class Device {
  Device(this.id);
  String id;
  int deviceType;
  String deviceName;
  // url prefix
  String url;
  int messagePort;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Device) {
      return id == other.id;
    }
    return false;
  }

  static Color getColor(int type) {
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
    try {
      history = (jsonDecode('history'.get) as List<dynamic>).cast();
      history = history.toSet().toList();
      history.removeWhere((element) => element.contains('null'));
      Future.delayed(const Duration(milliseconds: 200), () {
        history.forEach(sendJoinEvent);
      });
      Log.i('历史IP地址：$history');
    } catch (e) {
      Log.e('DeviceController error :$e');
    }
  }
  List<Device> connectDevice = [];
  List<String> history = [];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void onDeviceConnect(
    String id,
    String name,
    int type,
    String urlPrefix,
    int port,
  ) {
    Device device = Device(id)
      ..deviceType = type
      ..deviceName = name
      ..url = urlPrefix
      ..messagePort = port;
    if (!connectDevice.contains(device)) {
      connectDevice.add(device);
      addHistory('$urlPrefix:$port');
      Log.i('device : $device');
    }
    update();
  }

  void onDeviceClose(String id) {
    connectDevice.remove(Device(id));
    update();
  }

  void clear() {
    connectDevice.clear();
    update();
  }

  void addHistory(String url) {
    history.add(url);
    'history'.set = jsonEncode(history);
  }

  send(Map<String, dynamic> data) async {
    Set<String> urls = {};
    for (Device device in connectDevice) {
      // Log.i('${device.url}:${device.messagePort}');
      urls.add('${device.url}:${device.messagePort}');
    }
    for (String url in history) {
      urls.add('$url');
    }
    for (String url in urls) {
      Log.i('$url');
      try {
        Response res = await httpInstance.post('$url', data: data);
      } catch (e) {
        Log.e('send error : $e');
      }
    }
  }
}
