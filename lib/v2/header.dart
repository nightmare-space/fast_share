import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';

import 'menu.dart';

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
            SizedBox(width: 4.w),
            Text(
              '当前房间：',
              style: TextStyle(
                fontSize: 16.w,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            GetBuilder<ChatController>(builder: (_) {
              return SizedBox(
                height: 32.w,
                child: Material(
                  borderRadius: BorderRadius.circular(8.w),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Center(
                      child: SelectableText(
                        controller.chatServerAddress,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        Expanded(
          child: Transform(
            transform: Matrix4.identity()..translate(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 16.w),
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
