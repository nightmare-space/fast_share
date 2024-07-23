import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/app/controller/history.dart';
import 'package:speed_share/generated/l10n.dart';
import 'package:speed_share/modules/file/file_page.dart';

/// 主页中，最近连接的卡片
class RecentConnectContainer extends StatefulWidget {
  const RecentConnectContainer({Key? key}) : super(key: key);

  @override
  State<RecentConnectContainer> createState() => _RecentConnectContainerState();
}

class _RecentConnectContainerState extends State<RecentConnectContainer> {
  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      height: 200.w,
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                S.current.recentConnect,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              InkWell(
                onTap: () {
                  DeviceController deviceController = Get.find();
                  deviceController.clearHistory();
                  showToast(S.current.clearSuccess);
                },
                child: Icon(
                  Icons.delete,
                  size: 20.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.w),
          Expanded(
            child: GetBuilder<DeviceController>(
              builder: (ctl) {
                List<Widget> children = [];
                for (History history in ctl.historys.datas!) {
                  children.add(
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  basename(history.deviceName!),
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    color: Theme.of(context).textTheme.bodyMedium!.color,
                                    height: 1,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ID:',
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                                      ),
                                    ),
                                    Text(
                                      basename(history.id ?? ''),
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 14.w,
                                        color: Theme.of(context).textTheme.bodyMedium!.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20.w,
                                child: Center(
                                  child: Text(
                                    basename(history.url!),
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14.w,
                                      color: Theme.of(context).textTheme.bodyMedium!.color,
                                    ),
                                  ),
                                ),
                              ),
                              Builder(builder: (context) {
                                Device? device;
                                try {
                                  device = ctl.connectDevice.firstWhere(
                                    (element) {
                                      return element.id == history.id;
                                    },
                                  );
                                  // ignore: empty_catches
                                } catch (e) {}
                                if (device == null) {
                                  return const SizedBox();
                                }
                                return Container(
                                  decoration: BoxDecoration(
                                    color: device.isConnect! ? Theme.of(context).primaryColor.withOpacity(0.08) : Colors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12.w),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 2.w,
                                  ),
                                  child: Text(
                                    device.isConnect! ? S.current.connected : S.current.disconnected,
                                    style: TextStyle(
                                      color: device.isConnect! ? Theme.of(context).primaryColor : Colors.red,
                                      fontSize: 12.w,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                  children.add(
                    SizedBox(
                      width: 4.w,
                    ),
                  );
                }
                if (children.isEmpty) {
                  return Center(
                    child: Text(
                      S.current.empty,
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
