import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/download_controller.dart';
import 'package:speed_share/app/controller/setting_controller.dart';
import 'package:speed_share/app/controller/utils/server_util.dart';
import 'package:speed_share/model/model.dart';
import 'package:path/path.dart' as p;
import 'package:get/get.dart' hide Response;
import 'package:speed_share/modules/dialog/show_qr_page.dart';
import 'package:speed_share/modules/widget/icon.dart';
import 'package:speed_share/speed_share.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:speed_share/utils/ext_util.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:shelf/shelf_io.dart' as io;

class FileItem extends StatefulWidget {
  /// 消息model
  final FileMessage? info;

  /// 是否是本机发送的消息
  final bool? sendByUser;

  const FileItem({
    Key? key,
    this.info,
    this.sendByUser,
  }) : super(key: key);
  @override
  State createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  ChatController chatController = Get.find();
  SettingController settingController = Get.find();
  DownloadController downloadController = Get.find();
  FileMessage? info;

  DateTime? startTime;
  bool isStarted = false;
  // 执行下载文件

  @override
  void initState() {
    super.initState();
    info = widget.info;
    // 开启自动下载，且是来自其他设备的消息
    if (!GetPlatform.isWeb && canAutoDownload()) {
      downloadController.downloadFile(url, settingController.savePath);
    }
  }

  bool canAutoDownload() {
    if (widget.sendByUser!) {
      return false;
    }
    if (downloadController.progress.containsKey(url) && downloadController.progress[url]!.progress != 0.0) {
      return false;
    }
    if (!settingController.enableAutoDownload) return false;
    String type = url.getType;
    String savePath = '${settingController.savePath}/$type/${p.basename(url)}';
    File file = File(savePath);
    if (!file.existsSync()) {
      return true;
    }
    int len = file.lengthSync();
    if (file.existsSync()) {
      if (widget.info!.fileSize != FileSizeUtils.getFileSize(len)) return true;
      if (widget.info!.fileSize == FileSizeUtils.getFileSize(len)) return false;
    }
    return true;
  }

  String get url {
    String url;
    if (widget.sendByUser!) {
      url = 'http://127.0.0.1:${chatController.shelfBindPort}${widget.info!.filePath}';
    } else {
      url = widget.info!.url! + widget.info!.filePath!;
    }
    return url;
  }

  Offset? offset;
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
            onLongPress: () {
              Get.dialog(
                Menu(
                  offset: offset,
                  info: widget.info,
                ),
                useSafeArea: false,
                barrierColor: Colors.black12,
              );
            },
            onTap: () {
              // 打开文件
              // OpenFile.open(widget.info.path);
            },
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
                      Log.e('web download $url');
                      await canLaunchUrlString(url) ? await launchUrlString('$url?download=true') : throw 'Could not launch $url';
                      return;
                    }
                    if (GetPlatform.isDesktop) {
                      final dir = settingController.savePath;
                      Log.e(' -> $url');
                      downloadController.downloadFile(url, dir);
                    } else {
                      Directory dataDir = Directory('/sdcard/SpeedShare');
                      if (!dataDir.existsSync()) {
                        dataDir.createSync();
                      }
                      downloadController.downloadFile(
                        url,
                        '/sdcard/SpeedShare',
                      );
                    }
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
                  onTap: () async {
                    showToast('链接已复制');
                    await Clipboard.setData(ClipboardData(text: url));
                  },
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
  Widget buildPreviewWidget(String url) {
    return InkWell(
      child: Row(
        children: [
          getIconByExt(url),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              widget.info!.fileName!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 12.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({Key? key, this.offset, this.info}) : super(key: key);
  final Offset? offset;

  /// 消息model
  final FileMessage? info;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Future<int> server(String? path) async {
    final app = Router();
    int singlePort = Random().nextInt(10000) + 10000;
    Log.i(singlePort);
    int? port = Get.find<ChatController>().shelfBindPort;
    app.get('/', (Request request) {
      corsHeader[HttpHeaders.contentTypeHeader] = ContentType.html.toString();
      return Response.ok(
        singleFileDownloadHtml
            .replaceAll('placeholder3', ":$port$path")
            .replaceAll(
              'placeholder2',
              FileSizeUtils.getFileSize(File(path!).lengthSync())!,
            )
            .replaceAll('placeholder1', p.basename(path)),
        headers: corsHeader,
      );
    });
    app.get('/icon.png', (Request request) async {
      corsHeader[HttpHeaders.contentTypeHeader] = 'image/png';
      final ByteData byteData = await rootBundle.load(
        '${Config.flutterPackage}assets/icon/${getIconFromPath(path!)}.png',
      );
      final Uint8List picBytes = byteData.buffer.asUint8List();
      return Response.ok(
        picBytes,
        headers: corsHeader,
      );
    });
    io.serve(
      app,
      InternetAddress.anyIPv4,
      singlePort,
      shared: true,
    );
    return singlePort;
  }

  // TODO 这个页面没有适配暗色主题
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          top: widget.offset!.dy,
          left: min(widget.offset!.dx, MediaQuery.of(context).size.width - 120.w),
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: Theme.of(context).colorScheme.background,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(10.w),
              child: SizedBox(
                width: 120.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        height: 40.w,
                        child: const Center(child: Text('分享')),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        int port = await server(widget.info!.filePath);
                        Get.back();
                        Get.dialog(ShowQRPage(
                          port: port,
                        ));
                      },
                      child: SizedBox(
                        height: 40.w,
                        child: const Center(
                          child: Text('下载二维码'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
