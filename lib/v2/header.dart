import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:logger_view/logger_view.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/pages/dialog/join_chat.dart';
import 'package:speed_share/pages/item/file_item.dart';
import 'package:speed_share/utils/scan_util.dart';

import 'menu.dart';
import 'setting_page.dart';
import 'show_qr_page.dart';
// 主页显示的最上面那个header
class Header extends StatelessWidget {
  const Header({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.to(const SettingPage());
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
        Transform(
          transform: Matrix4.identity()..translate(4.w),
          child: Row(
            children: [
              NiIconButton(
                onTap: () {
                  Get.dialog(HeaderMenu(
                    offset: Offset(MediaQuery.of(context).size.width, 40),
                  ));
                },
                child: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
