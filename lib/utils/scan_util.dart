import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/routes/app_pages.dart';
import 'package:speed_share/pages/qrscan_page.dart';

class ScanUtil {
  static Future<void> parseScan() async {
    await PermissionUtil.requestCamera();
    final String cameraScanResult = await Get.to(
      const QrScan(),
      preventDuplicates: false,
      fullscreenDialog: true,
    );
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
