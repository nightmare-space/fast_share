import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/modules/qrscan_page.dart';

// 解析二维码
class ScanUtil {
  static Future<void> parseScan() async {
    await PermissionUtil.requestCamera();
    final String cameraScanResult = await Get.to(
      () => const QRScanPage(),
      preventDuplicates: false,
      fullscreenDialog: true,
    );
    if (cameraScanResult == null) {
      return;
    }
    Log.v('cameraScanResult -> $cameraScanResult');
    final List<String> localAddress = await PlatformUtil.localAddress();
    Log.v(localAddress);
    ChatController chatController = Get.find();
    chatController.initChat(cameraScanResult);
  }
}
