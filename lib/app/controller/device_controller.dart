import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';

class DeviceController extends GetxController {
  DeviceController();
  
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

}
