import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';

class DesktopDrawer extends StatefulWidget {
  const DesktopDrawer({
    Key key,
    this.value,
    this.onChange,
  }) : super(key: key);

  final dynamic value;
  final void Function(int value) onChange;

  @override
  State<DesktopDrawer> createState() => _DesktopDrawerState();
}

class _DesktopDrawerState extends State<DesktopDrawer> {
  String getIcon(int type) {
    switch (type) {
      case 0:
        return 'assets/icon/phone.png';
        break;
      case 1:
        return 'assets/icon/computer.png';
        break;
      case 2:
        return 'assets/icon/broswer.png';
        break;
      default:
        return 'assets/icon/computer.png';
    }
  }

  ChatController chatController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                GetBuilder<DeviceController>(builder: (controller) {
                  return Column(
                    children: [
                      DrawerItem(
                        groupValue: widget.value,
                        value: 0,
                        onChange: (v) {
                          setState(() {});
                          widget.onChange?.call(v);
                        },
                        builder: (_) {
                          return Row(
                            children: [
                              Image.asset(
                                'assets/icon/home.png',
                                width: 16.w,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '首页',
                                style: TextStyle(
                                  color: Theme.of(_).textTheme.bodyText2.color,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      DrawerItem(
                        groupValue: widget.value,
                        value: 1,
                        onChange: (v) {
                          setState(() {});
                          chatController.restoreList();
                          widget.onChange?.call(v);
                        },
                        builder: (_) {
                          return Row(
                            children: [
                              Image.asset(
                                'assets/icon/all.png',
                                width: 16.w,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '消息窗口',
                                style: TextStyle(
                                  color: Theme.of(_).textTheme.bodyText2.color,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      GetBuilder<DeviceController>(builder: (_) {
                        return Column(
                          children: [
                            for (int i = 0; i < _.connectDevice.length; i++)
                              DrawerItem(
                                groupValue: widget.value,
                                value: i + 2,
                                onChange: (v) {
                                  widget.onChange?.call(v);
                                  chatController
                                      .changeListToDevice(_.connectDevice[i]);
                                  setState(() {});
                                },
                                builder: (context) {
                                  return Row(
                                    children: [
                                      Image.asset(
                                        getIcon(_.connectDevice[i].deviceType),
                                        width: 16.w,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '文件管理(${_.connectDevice[i].deviceName})',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .color,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                          ],
                        );
                      }),
                      DrawerItem(
                        groupValue: widget.value,
                        value: controller.connectDevice.length + 2,
                        onChange: (v) {
                          setState(() {});
                          widget.onChange?.call(v);
                        },
                        builder: (_) {
                          return Row(
                            children: [
                              Image.asset(
                                'assets/icon/file.png',
                                width: 16.w,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '文件管理(本地)',
                                style: TextStyle(
                                  color: Theme.of(_).textTheme.bodyText2.color,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      DrawerItem(
                        groupValue: widget.value,
                        value: controller.connectDevice.length + 3,
                        onChange: (v) {
                          setState(() {});
                          widget.onChange?.call(v);
                        },
                        builder: (_) {
                          return Row(
                            children: [
                              Image.asset(
                                'assets/icon/setting.png',
                                width: 16.w,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '设置',
                                style: TextStyle(
                                  color: Theme.of(_).textTheme.bodyText2.color,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          Container(
            width: 1,
            height: MediaQuery.of(context).size.height,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key key,
    this.groupValue,
    this.value,
    this.builder,
    this.onChange,
  }) : super(key: key);
  final dynamic groupValue;
  final dynamic value;
  final WidgetBuilder builder;
  final void Function(int value) onChange;
  bool get enable => groupValue == value;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange?.call(value);
      },
      child: Container(
        width: 160.w,
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.w,
        ),
        decoration: BoxDecoration(
          color:
              enable ? Theme.of(context).primaryColor.withOpacity(0.11) : null,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              bodyText2: TextStyle(
                color: enable ? Theme.of(context).primaryColor : Colors.black,
              ),
            ),
          ),
          child: Builder(
            builder: builder,
          ),
        ),
      ),
    );
  }
}
