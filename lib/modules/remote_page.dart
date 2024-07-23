import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/generated/l10n.dart';
import 'package:speed_share/global/constant.dart';
import 'package:file_manager_view/file_manager_view.dart' as fm;
import 'package:speed_share/themes/theme.dart';
import 'widget/header.dart';

class RemotePage extends StatefulWidget {
  const RemotePage({Key? key}) : super(key: key);

  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  Widget? page;
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
    S? s = S.of(context);
    return GetBuilder<DeviceController>(builder: (controller) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const Header(),
          ),
          SizedBox(height: 10.w),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface1,
                borderRadius: BorderRadius.circular(12.w),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.remoteAccessFile,
                    style: TextStyle(
                      fontSize: 18.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(s.remoteAccessDes),
                  SizedBox(
                    height: chatController.addrs.length * 18.w,
                    child: ListView.builder(
                      itemCount: chatController.addrs.length,
                      itemBuilder: (context, index) {
                        return SelectableText(
                          'http://${chatController.addrs[index]}:12000/',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  child: GestureWithScale(
                    onTap: () {
                      Log.i(device);
                      Uri uri = Uri.tryParse(device.url!)!;
                      page = fm.FileManager(
                        address: 'http://${uri.host}:${fm.Config.port}',
                        usePackage: true,
                        path: device.deviceType == desktop ? '/Users' : '/sdcard',
                      );
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: device.deviceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      padding: EdgeInsets.all(24.w),
                      margin: EdgeInsets.symmetric(vertical: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                device.deviceName!,
                                style: TextStyle(
                                  fontSize: 20.w,
                                  fontWeight: FontWeight.bold,
                                  color: device.deviceColor,
                                ),
                              ),
                              SizedBox(height: 10.w),
                              Text(
                                S.of(context).tapToViewFile(device.deviceName!),
                                style: TextStyle(color: device.deviceColor),
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
