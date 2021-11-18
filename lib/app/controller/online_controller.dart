import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:global_repository/global_repository.dart';

class DeviceEntity {
  DeviceEntity(this.unique, this.address, this.port);
  final String unique;
  final String address;
  final int port;
  @override
  String toString() {
    return 'unique:$unique address:$address';
  }

  @override
  bool operator ==(dynamic other) {
    // 判断是否是非
    if (other is! DeviceEntity) {
      return false;
    }
    if (other is DeviceEntity) {
      return other.address == address;
    }
    return false;
  }

  @override
  int get hashCode => address.hashCode;
}

class OnlineController extends GetxController {
  final list = <DeviceEntity>[].obs;
  final Debouncer _debouncer = Debouncer(
    delay: const Duration(
      seconds: 2,
    ),
  );
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void updateDevices(DeviceEntity devices) {
    // Log.w('list -> $list');
    if (!list.contains(devices)) {
      list.add(devices);
    } else {
      // list.firstWhere((element) =>element.address== devices.address);
    }

    _debouncer.call(() {
      removeOnlineItem(devices);
    });
    update();
  }

  void removeOnlineItem(DeviceEntity devices) {
    list.remove(devices);
    update();
    // Log.w('removeOnlineItem -> $list');
  }
}
