
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/model/model.dart';
import 'package:speed_share/modules/widget/icon.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:speed_share/utils/utils.dart';

class BroswerFileItem extends StatefulWidget {
  /// 消息model
  final BroswerFileMessage? info;

  /// 是否是本机发送的消息
  final bool? sendByUser;

  const BroswerFileItem({
    Key? key,
    this.info,
    this.sendByUser,
  }) : super(key: key);
  @override
  State createState() => _BroswerFileItemState();
}

class _BroswerFileItemState extends State<BroswerFileItem> {
  ChatController chatController = Get.find();
  SettingController settingController = Get.find();
  DownloadController downloadController = Get.find();
  BroswerFileMessage? info;

  DateTime? startTime;
  bool isStarted = false;
  // 执行下载文件

  @override
  void initState() {
    super.initState();
    info = widget.info;
  }

  Offset? offset;

  String? get url {
    String? url;
    if (widget.sendByUser!) {
      url = widget.info!.blob;
    } else {
      url = widget.info!.blob;
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: widget.sendByUser! ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Material(
          color: Theme.of(context).surface1,
          borderRadius: BorderRadius.circular(10.w),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onLongPress: () {},
            child: GestureDetector(
              onTapDown: (details) {
                offset = details.globalPosition;
              },
              child: body(context),
            ),
          ),
        ),
        // 展示下载按钮
        if (!widget.sendByUser!)
          Material(
            color: Colors.transparent,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    if (GetPlatform.isWeb) {
                      return;
                    }
                    showToast('通知浏览器上传文件，这会比客户端慢一点');
                    chatController.notifyBroswerUploadFile(widget.info!.hash);
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
                InkWell(
                  onTap: () async {},
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.content_copy,
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

  Padding body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 200.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (context) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // if (fileDownratio == 1.0 && !timer.isActive) {
                  //   OpenFile.open(savePath);
                  // }
                },
                child: buildPreviewWidget(url),
              );
            }),
            // 展示下载进度条
            if (!widget.sendByUser! && !GetPlatform.isWeb)
              GetBuilder<DownloadController>(builder: (context) {
                DownloadInfo info = downloadController.getInfo(url)!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 8.w,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                      child: Builder(builder: (context) {
                        double pro = info.progress;
                        return LinearProgressIndicator(
                          backgroundColor: Theme.of(context).colorScheme.surface3,
                          valueColor: AlwaysStoppedAnimation(
                            pro == 1.0 ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.4),
                          ),
                          value: pro,
                        );
                      }),
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(builder: (_) {
                          double pro = downloadController.getProgress(url);
                          // timer.isActive说明正在下载，说明文件完整下载了，但是还没有合并
                          // if (pro == 1.0 && timer.isActive) {
                          //   return Text(
                          //     '合并文件中',
                          //     style: TextStyle(
                          //       color: Colors.black54,
                          //       fontSize: 12.w,
                          //     ),
                          //   );
                          // }
                          if (pro == 1.0) {
                            return Icon(
                              Icons.check,
                              size: 16.w,
                              color: Colors.green,
                            );
                          }
                          return Text(
                            '${info.speed}/s',
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
                                FileSizeUtils.getFileSize(info.count)!,
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
                                widget.info!.fileSize!,
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
                );
              }),
          ],
        ),
      ),
    );
  }

  UniqueKey key = UniqueKey();
  Widget buildPreviewWidget(String? url) {
    return InkWell(
      child: Row(
        children: [
          if (widget.info!.fileName!.isImg && widget.sendByUser!)
            // 文件名是图片的时候，用blob协议展示
            Hero(
              tag: widget.info!.blob!,
              child: GestureDetector(
                onTap: () {
                  FileUtil.openFile(widget.info!.blob!);
                },
                child: Image(
                  width: 36.w,
                  height: 36.w,
                  fit: BoxFit.cover,
                  image: ResizeImage(
                    NetworkImage(widget.info!.blob!),
                    width: 100,
                  ),
                ),
              ),
            )
          else
            // 传入文件名，已展示对应的图标
            getIconByExt(widget.info!.fileName!),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              widget.info!.fileName!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
