import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/speed_share.dart';

class DesktopDrawer extends StatefulWidget {
  const DesktopDrawer({
    Key? key,
    this.value,
    this.onChange,
  }) : super(key: key);

  final dynamic value;
  final void Function(int value)? onChange;

  @override
  State<DesktopDrawer> createState() => _DesktopDrawerState();
}

class _DesktopDrawerState extends State<DesktopDrawer> {
  String getIcon(int? type) {
    switch (type) {
      case 0:
        return 'assets/icon/phone.png';
      case 1:
        return 'assets/icon/computer.png';
      case 2:
        return 'assets/icon/broswer.png';
      default:
        return 'assets/icon/computer.png';
    }
  }

  ChatController chatController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                GetBuilder<DeviceController>(builder: (controller) {
                  if (GetPlatform.isWeb) {
                    return Column(
                      children: [
                        messageMenu(),
                        fileMenu(),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (personHeader != null)
                        Column(
                          children: [
                            SizedBox(
                              width: 240.w,
                              child: personHeader,
                            ),
                            SizedBox(height: 8.w),
                          ],
                        ),
                      homeMenu(),
                      messageMenu(),
                      fileMenu(),
                      localFileMenu(controller),
                      settingMenu(controller),
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

  DrawerItem settingMenu(DeviceController controller) {
    return DrawerItem(
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
              color: Theme.of(_).textTheme.bodyMedium!.color,
              width: 16.w,
            ),
            SizedBox(width: 4.w),
            Text(
              '设置',
              style: TextStyle(
                color: Theme.of(_).textTheme.bodyMedium!.color,
              ),
            ),
          ],
        );
      },
    );
  }

  DrawerItem localFileMenu(DeviceController controller) {
    return DrawerItem(
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
              color: Theme.of(_).textTheme.bodyMedium!.color,
            ),
            SizedBox(width: 4.w),
            Text(
              '文件管理(本地)',
              style: TextStyle(
                color: Theme.of(_).textTheme.bodyMedium!.color,
              ),
            ),
          ],
        );
      },
    );
  }

  GetBuilder<DeviceController> fileMenu() {
    return GetBuilder<DeviceController>(builder: (_) {
      return Column(
        children: [
          for (int i = 0; i < _.connectDevice.length; i++)
            DrawerItem(
              groupValue: widget.value,
              value: i + 2,
              onChange: (v) {
                widget.onChange?.call(v);
                chatController.changeListToDevice(_.connectDevice[i]);
                setState(() {});
              },
              builder: (context) {
                return Row(
                  children: [
                    Image.asset(
                      getIcon(_.connectDevice[i].deviceType),
                      width: 16.w,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '文件管理(${_.connectDevice[i].deviceName})',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      );
    });
  }

  DrawerItem messageMenu() {
    return DrawerItem(
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
              color: Theme.of(_).textTheme.bodyMedium!.color,
            ),
            SizedBox(width: 4.w),
            Text(
              '消息窗口',
              style: TextStyle(
                color: Theme.of(_).textTheme.bodyMedium!.color,
              ),
            ),
          ],
        );
      },
    );
  }

  DrawerItem homeMenu() {
    return DrawerItem(
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
              'assets/icon/homev2.png',
              width: 16.w,
              color: Theme.of(_).textTheme.bodyMedium!.color,
            ),
            SizedBox(width: 4.w),
            Text(
              '首页',
              style: TextStyle(
                color: Theme.of(_).textTheme.bodyMedium!.color,
              ),
            ),
          ],
        );
      },
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    this.groupValue,
    this.value,
    this.builder,
    this.onChange,
  }) : super(key: key);
  final dynamic groupValue;
  final dynamic value;
  final WidgetBuilder? builder;
  final void Function(int value)? onChange;
  bool get enable => groupValue == value;
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        onChange?.call(value);
      },
      borderRadius: BorderRadius.circular(8.w),
      child: Container(
        width: 200.w,
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.w,
        ),
        decoration: BoxDecoration(
          color: enable ? Theme.of(context).primaryColor.withOpacity(0.11) : null,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              bodyMedium: TextStyle(
                color: enable ? Theme.of(context).primaryColor : (isDark ? Colors.white : Colors.black),
              ),
            ),
          ),
          child: Builder(
            builder: builder!,
          ),
        ),
      ),
    );
  }
}
