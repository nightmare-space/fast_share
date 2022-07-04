import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/utils/http/http.dart';

class Device {
  Device(this.id);
  String id;
  int deviceType;
  String deviceName;
  // 一个可以互通的ip:port
  String address;
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
    return 'id:$id deviceType:$deviceType deviceName:$deviceName address:$address';
  }
}

// 用于管理设备连接的类
class DeviceController extends GetxController {
  DeviceController();
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
    String id,
    String name,
    int type,
    String addr,
    int port,
  ) {
    Device device = Device(id)
      ..deviceType = type
      ..deviceName = name
      ..address = addr
      ..messagePort = port;
    if (!connectDevice.contains(device)) {
      connectDevice.add(device);
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

  send(Map<String, dynamic> data) {
    for (Device device in connectDevice) {
      Uri uri = Uri.parse(device.address);
      Log.i('http://${uri.host}/${device.messagePort}');
      httpInstance.post('http://${uri.host}:${device.messagePort}', data: data);
    }
  }
}
