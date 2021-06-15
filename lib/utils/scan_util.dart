import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:speed_share/app/routes/app_pages.dart';

class ScanUtil {
  static Future<void> parseScan() async {
    await PermissionUtil.requestCamera();
    final String cameraScanResult = await scanner.scan();
    if (cameraScanResult == null) {
      return;
    }
    print('cameraScanResult -> $cameraScanResult');
    final List<String> localAddress = await PlatformUtil.localAddress();
    print(localAddress);
    Get.toNamed(
      '${Routes.chat}?needCreateChatServer=false&chatServerAddress=$cameraScanResult',
    );
  }
}
