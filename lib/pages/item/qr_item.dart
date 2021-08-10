import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:global_repository/global_repository.dart';

class QrMessageItem extends StatelessWidget {
  final String data;

  const QrMessageItem({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: QrImage(
        backgroundColor: Colors.white,
        data: data,
        version: QrVersions.auto,
        size: 240.w,
      ),
    );
  }
}
