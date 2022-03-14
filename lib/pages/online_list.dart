import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/online_controller.dart';
import 'package:speed_share/app/routes/app_pages.dart';
import 'package:speed_share/themes/app_colors.dart';

class OnlineList extends StatelessWidget {
  const OnlineList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnlineController>(
      builder: (ctl) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
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
                          height: 52.w,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xffeeeeee).withOpacity(0.6),
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
                                        Get.toNamed(
                                          '${Routes.chat}?needCreateChatServer=false&chatServerAddress=http://${device.address}:${device.port}',
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
          ),
        );
      },
    );
  }
}
