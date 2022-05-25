import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';

class Device {
  Device(this.id);
  String id;
  int deviceType;
  String deviceName;
  // 一个可以互通的ip:port
  String address;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Device) {
      return id == other.id;
    }
    return false;
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
  ) {
    Device device = Device(id)
      ..deviceType = type
      ..deviceName = name
      ..address = addr;
    Log.i('device : $device');
    connectDevice.add(device);
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
}
