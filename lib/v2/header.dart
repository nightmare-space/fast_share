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
  const Header({
    Key key,
    this.showAddress = true,
  }) : super(key: key);
  final bool showAddress;

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                'http://nightmare.fun/YanTool/image/hong.jpg',
                width: 30.w,
                height: 30.w,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              '梦魇兽',
              style: TextStyle(
                fontSize: 16.w,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            SizedBox(width: 4.w),
            if (!GetPlatform.isWeb)
              ValueListenableBuilder<bool>(
                valueListenable: controller.connectState,
                builder: (_, value, __) {
                  return Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                        color: value ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(16.w)),
                  );
                },
              ),
          ],
        ),
        Expanded(
          child: Transform(
            transform: Matrix4.identity()..translate(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 16.w),
                if (showAddress)
                  Expanded(
                    child: GetBuilder<ChatController>(builder: (context) {
                      return SizedBox(
                        height: 32.w,
                        child: Material(
                          borderRadius: BorderRadius.circular(12.w),
                          color: Colors.white,
                          child: PageView.builder(
                            itemCount: controller.addrs.length,
                            itemBuilder: (context, index) {
                              return Center(
                                child: SelectableText(
                                  'http://${controller.addrs[index]}:12000/',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
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
        ),
      ],
    );
  }
}
