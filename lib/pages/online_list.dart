import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/online_controller.dart';
import 'package:speed_share/app/routes/app_pages.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/themes/app_colors.dart';
// 主页顶部显示局域网文件的组件
class OnlineList extends StatelessWidget {
  const OnlineList({
    Key key,
    this.onJoin,
  }) : super(key: key);
  final void Function(String address) onJoin;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnlineController>(
      builder: (ctl) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ctl.list.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 4.w, left: 8.w),
                child: const Text(
                  '点击 √ 加入房间',
                  style: TextStyle(
                    color: AppColors.fontColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Builder(
              builder: (context) {
                List<Widget> children = [];
                for (DeviceEntity device in ctl.list) {
                  children.add(
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.w),
                      child: Container(
                        height: 48.w,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  device.address,
                                  style: TextStyle(
                                    color: AppColors.fontColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.w,
                                  ),
                                ),
                                Text(
                                  '(${device.unique})',
                                  style: TextStyle(
                                    color: AppColors.fontColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.w,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                // Material(
                                //   color: Colors.transparent,
                                //   child: NiIconButton(
                                //     onTap: () {},
                                //     child: Icon(Icons.clear),
                                //   ),
                                // ),
                                Material(
                                  color: Colors.transparent,
                                  child: NiIconButton(
                                    onTap: () {
                                      Global().stopSendBoardcast();
                                      if (onJoin != null) {
                                        onJoin(
                                          'http://${device.address}:${device.port}',
                                        );
                                        return;
                                      }
                                      
                                      Get.toNamed(
                                        '${Routes.chat}?chatServerAddress=http://${device.address}:${device.port}',
                                      );
                                    },
                                    child: const Icon(Icons.check),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: children,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
