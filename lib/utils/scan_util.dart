import 'dart:io';

import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/app/controller/utils/join_util.dart';
import 'package:speed_share/modules/qrscan_page.dart';

/// 解析二维码
class ScanUtil {
  static Future<void> parseScan() async {
    if (Platform.isAndroid) {
      await PermissionUtil.requestCamera();
    }
    final String? cameraScanResult = await Get.to(
      () => const QRScanPage(),
      preventDuplicates: false,
      fullscreenDialog: true,
    );
    if (cameraScanResult == null) {
      return;
    }
    Log.v('cameraScanResult -> $cameraScanResult');
    ChatController controller = Get.find();
    JoinUtil.sendJoinEvent(
      controller.addrs,
      controller.shelfBindPort,
      controller.messageBindPort,
      cameraScanResult,
    );
  }
}
