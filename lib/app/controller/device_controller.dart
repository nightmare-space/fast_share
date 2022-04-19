import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';

class Device {
  Device(this.id);
  String id;
  int deviceType;
  String deviceName;
  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Device) {
      return id == other.id;
    }
    return false;
  }
}

class DeviceController extends GetxController {
  DeviceController();
  List<Device> connectDevice = [];

  @override
  void onInit() {
    super.onInit();
    Log.w('$this init');
  }

  @override
  void onReady() {
    super.onReady();
    Log.w('$this onReady');
  }

  void onDeviceConnect(String id, String name, int type) {
    connectDevice.add(
      Device(id)
        ..deviceType = type
        ..deviceName = name,
    );
    update();
  }

  void onDeviceClose(String id) {
    connectDevice.remove(Device(id));
    update();
  }
}
