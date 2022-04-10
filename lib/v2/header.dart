import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/utils/scan_util.dart';

import 'setting_page.dart';

class Header extends StatelessWidget {
  const Header({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: (){
                Get.to(SettingPage());
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  'http://nightmare.fun/YanTool/image/hong.jpg',
                  width: 30.w,
                  height: 30.w,
                ),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(
              '梦魇兽',
              style: TextStyle(
                fontSize: 16.w,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Transform(
              transform: Matrix4.identity()..translate(12.w),
              child: NiIconButton(
                child: SvgPicture.asset(
                  GlobalAssets.qrCode,
                  color: Colors.black,
                  width: 24.w,
                ),
                onTap: () async {
                  ScanUtil.parseScan();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}