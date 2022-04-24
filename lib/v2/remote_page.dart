import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/global/constant.dart';
import 'package:speed_share/pages/item/message_item_factory.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:speed_share/v2/home_page.dart';
import 'package:file_manager_view/file_manager_view.dart';

import 'header.dart';

class RemotePage extends StatefulWidget {
  const RemotePage({Key key}) : super(key: key);

  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  Widget page;
  ChatController chatController = Get.find();
  @override
  Widget build(BuildContext context) {
    page ??= remoteList(context);
    return WillPopScope(
      onWillPop: () async {
        page = remoteList(context);
        setState(() {});
        return false;
      },
      child: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            fillColor: Colors.transparent,
            child: child,
          );
        },
        duration: const Duration(milliseconds: 600),
        layoutBuilder: (widgets) {
          return Material(
            color: Colors.transparent,
            child: Stack(
              children: widgets,
            ),
          );
        },
        child: page,
      ),
    );
  }

  GetBuilder<DeviceController> remoteList(BuildContext context) {
    return GetBuilder<DeviceController>(builder: (controller) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Header(),
          ),
          SizedBox(height: 10.w),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface2,
                borderRadius: BorderRadius.circular(12.w),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '远程访问本机',
                    style: TextStyle(
                      fontSize: 18.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('在浏览器打开以下IP地址，即可远程管理本机文件'),
                  SizedBox(
                    height: chatController.addrs.length * 18.w,
                    child: ListView.builder(
                      itemCount: chatController.addrs.length,
                      itemBuilder: (context, index) {
                        return SelectableText(
                          'http://${chatController.addrs[index]}:12000/',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.connectDevice.length,
              itemBuilder: (c, i) {
                Device device = controller.connectDevice[i];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: GestureWithScale(
                    onTap: () {
                      Log.i(device);
                      Uri uri = Uri.tryParse(device.address);
                      page = FileManager(
                        address: 'http://${uri.host}:20000',
                        usePackage: true,
                        path:
                            device.deviceType == desktop ? '/Users' : '/sdcard',
                      );
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: getColor(device.deviceType).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      padding: EdgeInsets.all(24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                device.deviceName,
                                style: TextStyle(
                                  fontSize: 20.w,
                                  fontWeight: FontWeight.bold,
                                  color: getColor(device.deviceType),
                                ),
                              ),
                              SizedBox(height: 10.w),
                              Text(
                                '点击即可访问${device.deviceName}的所有文件',
                                style: TextStyle(
                                  color: getColor(device.deviceType),
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
