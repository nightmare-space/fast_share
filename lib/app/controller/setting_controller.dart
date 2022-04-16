import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:signale/signale.dart';
import 'package:settings/settings.dart';

class SettingController extends GetxController {
  SettingController() {
    initConfig();
  }

  bool enableFilter = false;
  bool enableServer = true;
  bool enableAutoDownload = false;
  bool clipboardShare = true;
  bool vibrate = true;
  String savePath = '/sdcard/SpeedShare';

  void initConfig() {
    clipboardShare = 'clipboardShare'.get ?? true;
    vibrate = 'vibrate'.get ?? true;
    enableAutoDownload = 'enableAutoDownload'.get ?? true;
  }

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

  void clipChange(bool value) {
    clipboardShare = value;
    'clipboardShare'.set = clipboardShare;
    update();
  }

  void vibrateChange(bool value) {
    vibrate = value;
    'vibrate'.set = vibrate;
    update();
  }

  void enableAutoChange(bool value) {
    enableAutoDownload = value;
    'enableAutoDownload'.set = enableAutoDownload;
    update();
  }

  void filterEnabledChange(bool value) {
    enableFilter = value;
    update();
  }

  void serverEnableChange(bool value) {
    enableServer = value;
    update();
  }

  void changeSavepath(String path) {
    savePath = path;
    update();
  }
}
