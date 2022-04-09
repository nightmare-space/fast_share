import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';

class Device {
  Device(this.id);
  String id;
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

  void onDeviceConnect(String id) {
    connectDevice.add(Device(id));
    update();
  }
}
