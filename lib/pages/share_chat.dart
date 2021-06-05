import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:path/path.dart' as p;
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/themes/default_theme_data.dart';
import 'package:speed_share/utils/chat_server.dart';
import 'package:speed_share/utils/http/http.dart';
import 'package:speed_share/utils/shelf_static.dart';
import 'package:video_compress/video_compress.dart';

import 'item/message_item_factory.dart';
import 'model/model.dart';
import 'model/model_factory.dart';
import 'package:speed_share/utils/string_extension.dart';

class ShareChat extends StatefulWidget {
  const ShareChat({
    Key key,
    this.needCreateChatServer = true,
    this.chatServerAddress,
  }) : super(key: key);

  /// 为`true`的时候，会创建一个聊天服务器，如果为`false`，则代表加入已有的聊天
  final bool needCreateChatServer;
  final String chatServerAddress;
  @override
  _ShareChatState createState() => _ShareChatState();
}

class _ShareChatState extends State<ShareChat> {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  GetSocket socket;
  List<Widget> children = [];
  ScrollController scrollController = ScrollController();
  bool isConnect = false;
  String chatRoomUrl = '';
  @override
  void initState() {
    super.initState();
    initChat();
  }

  @override
  void dispose() {
    if (isConnect) {
      socket.close();
    }
    Global().stopSendBoradcast();
    focusNode.dispose();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: AppColors.accentColor,
        title: Text('文件共享'),
      ),
      body: GestureDetector(
        onTap: () {
          focusNode.unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                controller: scrollController,
                itemCount: children.length,
                cacheExtent: 99999,
                itemBuilder: (c, i) {
                  return children[i];
                },
              ),
            ),
            sendMsgContainer(context),
          ],
        ),
      ),
    );
  }

  Material sendMsgContainer(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 32,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, -4.0),
                  child: IconButton(
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.file_copy,
                      color: AppColors.accentColor,
                    ),
                    onPressed: () async {
                      if (GetPlatform.isAndroid) {
                        sendForAndroid();
                      }
                      if (GetPlatform.isDesktop) {
                        sendForDesktop();
                      }
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      controller: controller,
                      autofocus: false,
                      style: TextStyle(
                        textBaseline: TextBaseline.ideographic,
                      ),
                      onSubmitted: (_) {
                        sendTextMsg();
                        Future.delayed(Duration(milliseconds: 100), () {
                          focusNode.requestFocus();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Material(
                    color: AppColors.accentColor,
                    borderRadius: BorderRadius.circular(32),
                    borderOnForeground: true,
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: AppColors.surface,
                      ),
                      onPressed: () {
                        sendTextMsg();
                      },
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

  Future<void> sendForDesktop() async {
    final typeGroup = XTypeGroup(
      label: 'images',
    );
    final files = await FileSelectorPlatform.instance
        .openFiles(acceptedTypeGroups: [typeGroup]);
    if (files.isEmpty) {
      return;
    }
    for (XFile xFile in files) {
      final file = xFile;
      String filePath = file.path.replaceAll('\\', '/');
      File thumbnailFile;
      String msgType = '';
      Log.e(filePath);
      // return;
      if (filePath.isVideoFileName || filePath.endsWith('.mkv')) {
        msgType = 'video';
        thumbnailFile = await VideoCompress.getFileThumbnail(
          filePath,
          quality: 50,
          position: -1,
        );
      } else if (filePath.isImageFileName) {
        msgType = 'img';
      } else {
        msgType = 'other';
      }
      print('msgType $msgType');
      int size = await File(filePath).length();

      filePath = filePath.replaceAll(RegExp('^[A-Z]:'), '');
      String fileUrl = '';
      List<String> address = await PlatformUtil.localAddress();
      for (String addr in address) {
        fileUrl += 'http://' + addr + ':8002 ';
      }
      fileUrl = fileUrl.trim();
      MessageBaseInfo info = MessageInfoFactory.fromJson({
        'filePath': filePath,
        'msgType': msgType,
        'thumbnailPath': thumbnailFile?.path?.replaceAll(
          '/storage/emulated/0/',
          '',
        ),
        'fileName': p.basename(filePath),
        'fileSize': FileSizeUtils.getFileSize(size),
        'url': fileUrl,
      });
      Log.w(await PlatformUtil.localAddress());
      // 发送消息
      socket.send(info.toString());
      // 将消息添加到本地列表
      children.add(MessageItemFactory.getMessageItem(
        info,
        true,
      ));
      scroll();
      setState(() {});
    }
  }

  Future<void> sendForAndroid() async {
    // 选择文件路径
    String filePath = await FileManager.chooseFile(
      context: context,
      pickPath: '/storage/emulated/0',
    );
    print(filePath);
    if (filePath == null) {
      return;
    }
    String path = filePath.replaceAll(
      '/storage/emulated/0/',
      '/',
    );
    print(path);
    File thumbnailFile;
    String msgType = '';
    if (filePath.isVideoFileName || filePath.endsWith('.mkv')) {
      msgType = 'video';
      thumbnailFile = await VideoCompress.getFileThumbnail(
        filePath,
        quality: 50,
        position: -1,
      );
    } else if (filePath.isImageFileName) {
      msgType = 'img';
    } else {
      msgType = 'other';
    }
    print('msgType $msgType');
    int size = await File(filePath).length();
    String fileUrl = '';
    List<String> address = await PlatformUtil.localAddress();
    for (String addr in address) {
      fileUrl += 'http://' + addr + ':${Config.shelfPort} ';
    }
    fileUrl = fileUrl.trim();
    dynamic info = MessageInfoFactory.fromJson({
      'filePath': path,
      'msgType': msgType,
      'thumbnailPath': thumbnailFile?.path?.replaceAll(
        '/storage/emulated/0/',
        '',
      ),
      'fileName': p.basename(filePath),
      'fileSize': FileSizeUtils.getFileSize(size),
      'url': fileUrl,
    });
    // 发送消息
    socket.send(info.toString());
    // 将消息添加到本地列表
    children.add(MessageItemFactory.getMessageItem(
      info,
      true,
    ));
    scroll();
    setState(() {});
  }

  Future<void> initChat() async {
    if (widget.needCreateChatServer) {
      // 是创建房间的一端
      createChatServer();
      List<String> addreses = await PlatformUtil.localAddress();
      Global().startSendBoardCast(addreses.join(' '));
      chatRoomUrl = 'http://127.0.0.1:${Config.chatPort}';
    } else {
      chatRoomUrl = widget.chatServerAddress;
    }
    socket = GetSocket(chatRoomUrl + '/chat');
    Log.v('chat open');
    socket.onOpen(() {
      Log.d('chat连接成功');
      isConnect = true;
      getHistoryMsg();
    });

    try {
      await socket.connect();
      await Future.delayed(Duration.zero);
    } catch (e) {
      isConnect = false;
    }
    // 监听消息
    listenMessage();
    if (!isConnect && !GetPlatform.isWeb) {
      // 如果连接失败并且不是 web 平台
      children.add(MessageItemFactory.getMessageItem(
        MessageTextInfo(content: '加入失败!'),
        false,
      ));
      return;
    }
    if (widget.needCreateChatServer) {
      sendAddressAndQrCode();
    } else {
      children.add(MessageItemFactory.getMessageItem(
        MessageTextInfo(content: '已加入$chatRoomUrl'),
        false,
      ));
      setState(() {});
    }
    if (!GetPlatform.isWeb) {
      // 开启文件部署
      ShelfStatic.start();
    }
  }

  Future<void> sendAddressAndQrCode() async {
    // 这个if的内容是创建房间的设备，会得到本机ip的消息
    children.add(MessageItemFactory.getMessageItem(
      MessageTextInfo(
        content: '当前窗口可通过以下url加入，也可以使用浏览器直接打开以下url，'
            '只有同局域网下的设备能打开喔~',
      ),
      false,
    ));
    List<String> addreses = await PlatformUtil.localAddress();
    if (addreses.isEmpty) {
      children.add(MessageItemFactory.getMessageItem(
        MessageTextInfo(content: '未发现局域网IP'),
        false,
      ));
    } else {
      for (String address in addreses) {
        if (address.startsWith('10.')) {
          continue;
        }
        children.add(MessageItemFactory.getMessageItem(
          MessageTextInfo(content: 'http://$address:${Config.chatPort}'),
          false,
        ));
        children.add(MessageItemFactory.getMessageItem(
          MessageQrInfo(content: 'http://$address:${Config.chatPort}'),
          false,
        ));
      }
    }
    setState(() {});
    scroll();
  }

  void listenMessage() {
    socket.onMessage((message) async {
      // print('服务端的消息 - $message');
      if (message == '') {
        // 发来的空字符串就没必要解析了
        return;
      }
      Map<String, dynamic> map;
      try {
        map = jsonDecode(message);
      } catch (e) {
        return;
      }
      MessageBaseInfo messageInfo = MessageInfoFactory.fromJson(map);
      if (messageInfo is MessageFileInfo) {
        // for (String url in messageInfo.url.split(' ')) {
        //   Uri uri = Uri.parse(url);
        //   Log.d('${uri.scheme}://${uri.host}:7001');
        //   Response response;
        //   try {
        //     response = await httpInstance.get(
        //       '${uri.scheme}://${uri.host}:7001',
        //     );
        //     Log.w(response.data);
        //   } catch (e) {}
        //   if (response != null) {
        //     messageInfo.url = url;
        //   }
        // }
        if (!GetPlatform.isWeb) {
          for (String url in messageInfo.url.split(' ')) {
            Uri uri = Uri.parse(url);
            Log.v('消息带有的address -> ${uri.host}');
            for (String localAddr in await PlatformUtil.localAddress()) {
              if (uri.host.isSameSegment(localAddr)) {
                Log.d('其中消息的 -> ${uri.host} 与本地的$localAddr 在同一个局域网');
                messageInfo.url = url;
              }
            }
          }
        } else {
          messageInfo.url = messageInfo.url.split(' ').first;
        }
      }
      children.add(MessageItemFactory.getMessageItem(
        messageInfo,
        false,
      ));
      scroll();
      if (mounted) {
        setState(() {});
      }
    });
  }

  void getHistoryMsg() {
    // 这个消息来告诉聊天服务器，自己需要历史消息
    socket.send(jsonEncode({
      'type': "getHistory",
    }));
  }

  Future<void> scroll() async {
    // 让listview滚动
    await Future.delayed(Duration(milliseconds: 100));
    if (mounted) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.ease,
      );
    }
  }

  void sendTextMsg() {
    // 发送文本消息
    MessageTextInfo info = MessageTextInfo(
      content: controller.text,
      msgType: 'text',
    );
    socket.send(info.toString());
    children.add(MessageItemFactory.getMessageItem(
      info,
      true,
    ));
    setState(() {});
    controller.clear();
    scroll();
  }
}
