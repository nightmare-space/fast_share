import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/model/model.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/utils/file_server.dart';
import 'package:speed_share/themes/theme.dart';

class BroswerFileItem extends StatefulWidget {
  const BroswerFileItem({
    Key key,
    this.sendByUser,
    this.info,
  }) : super(key: key);
  final bool sendByUser;
  final BroswerFileMessage info;

  @override
  State createState() => _BroswerFileItemState();
}

class _BroswerFileItemState extends State<BroswerFileItem> {
  ChatController chatController = Get.find();
  double fileDownratio = 0.0;
  // 网速
  String speed = '0';

  int count = 0;
  @override
  Widget build(BuildContext context) {
    Color background = scheme.primary.withOpacity(0.05);
    if (widget.sendByUser) {
      background = AppColors.sendByUser;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          widget.sendByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.info.fileName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.w,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: SvgPicture.asset(
                        '${Config.flutterPackage}assets/icon/file.svg',
                        height: 40.w,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                // 展示下载进度条
                if (!widget.sendByUser && !GetPlatform.isWeb)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 8.w,
                      ),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0)),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.black12,
                          valueColor: AlwaysStoppedAnimation(
                            fileDownratio == 1.0 ? Colors.blue : Colors.red,
                          ),
                          value: fileDownratio,
                        ),
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(builder: (_) {
                            if (fileDownratio == 1.0) {
                              return Icon(
                                Icons.check,
                                size: 16.w,
                                color: Colors.green,
                              );
                            }
                            return Text(
                              '$speed/s',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12.w,
                              ),
                            );
                          }),
                          Row(
                            children: [
                              SizedBox(
                                child: Text(
                                  FileSizeUtils.getFileSize(count),
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.w,
                                  ),
                                ),
                              ),
                              Text(
                                '/',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.w,
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  widget.info.fileSize,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        // 展示下载按钮
        if (!widget.sendByUser)
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    if (GetPlatform.isWeb) {
                      showToast('浏览器不支持下载浏览器发送的文件');
                    } else {
                      progressCall = (pro, c) {
                        fileDownratio = pro;
                        count = c;
                        setState(() {});
                      };
                      chatController.notifyBroswerUploadFile(widget.info.hash);
                    }
                    // if (GetPlatform.isWeb) {
                    //   Log.e('web download');
                    //   await canLaunch(url)
                    //       ? await launch(url + '?download=true')
                    //       : throw 'Could not launch $url';
                    //   return;
                    // }
                    // if (GetPlatform.isDesktop) {
                    //   const confirmButtonText = 'Choose';
                    //   final dir =
                    //       await FileSelectorPlatform.instance.getDirectoryPath(
                    //     confirmButtonText: confirmButtonText,
                    //   );
                    //   if (dir == null) {
                    //     return;
                    //   }
                    //   Log.e(' -> $url');
                    //   downloadFile(url, dir);
                    // } else {
                    //   Directory dataDir = Directory('/sdcard/SpeedShare');
                    //   if (!dataDir.existsSync()) {
                    //     dataDir.createSync();
                    //   }
                    //   downloadFile(url, '/sdcard/SpeedShare');
                    // }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.file_download,
                      size: 18.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
