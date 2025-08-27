// // 常量岛
// import 'dart:ui';

// import 'package:android_window/main.dart';
// import 'package:get/get.dart';

// class ConstIsland {
//   // 当剪切板消息收到的时候
//   static void onClipboardReceive(String? deviceName) {
//     Size size = Get.size;
//     open(
//       // ignore: deprecated_member_use
//       size: Size(size.width * window.devicePixelRatio, 800),
//       position: const Offset(0, 0),
//       focusable: true,
//     );
//     Future.delayed(const Duration(milliseconds: 10), () async {
//       await post(
//         'clipboard',
//         '已复制$deviceName的剪切板',
//       );
//     });
//   }

//   static void onFileReceive(Map<String, dynamic> data) {
//     Size size = Get.size;
//     open(
//       // ignore: deprecated_member_use
//       size: Size(size.width * window.devicePixelRatio, 800),
//       position: const Offset(0, 0),
//       focusable: true,
//     );
//     Future.delayed(const Duration(milliseconds: 1000), () async {
//       await post(
//         'file_receive',
//         data,
//       );
//     });
//   }
//   // static void onFileReceive() {}
// }
