import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              // final Uint8List? image = capture.image;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                Get.back(result: code);
                debugPrint('Barcode found! ${barcode.rawValue}');
              }
            },
          ),
        ],
      ),
    );
  }
}
