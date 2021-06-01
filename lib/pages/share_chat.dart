import 'dart:convert';
import 'dart:io';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:path/path.dart' as p;
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/themes/default_theme_data.dart';
import 'package:speed_share/utils/chat_server.dart';
import 'package:speed_share/utils/shelf_static.dart';
import 'package:video_compress/video_compress.dart';

import 'item/message_item.dart';
import 'model/model.dart';
import 'model/model_factory.dart';

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
    focusNode.dispose();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: accentColor,
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
                itemBuilder: (c, i) {
                  return children[i];
                },
              ),
            ),
            Material(
              color: Theme.of(context).appBarTheme.color,
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
                              color: accentColor,
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
                            color: Color(0xffcfbff7),
                            borderRadius: BorderRadius.circular(32),
                            borderOnForeground: true,
                            child: IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Color(0xffede8f8),
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
            ),
          ],
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
    final file = files[0];
    final fileName = file.name;
    final filePath = file.path;

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
    // TODO
    // 如果创建房间的人需要发文件
    // 自身可能有多个ip，
    // 其他的设备也可能通过各个ip连接进来的
    String fileUrl = chatRoomUrl;
    // if (!widget.needCreateChatServer) {
    // 这个情况说明发送文件的设备，是加入的其他窗口
    // 逻辑是对的，别改了
    fileUrl = 'http://' + (await PlatformUtil.localAddress())[0] + ':8002';
    // }
    dynamic info = MessageInfoFactory.fromJson({
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
    Log.e(info);
    // 发送消息
    socket.send(info.toString());
    // 将消息添加到本地列表
    children.add(messageItem(
      info,
      true,
    ));
    scroll();
    setState(() {});
  }

  Future<void> sendForAndroid() async {
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
      '',
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
    // TODO
    // 如果创建房间的人需要发文件
    // 自身可能有多个ip，
    // 其他的设备也可能通过各个ip连接进来的
    String fileUrl = chatRoomUrl;
    // if (!widget.needCreateChatServer) {
    // 这个情况说明发送文件的设备，是加入的其他窗口
    // 逻辑是对的，别改了
    fileUrl = 'http://' + (await PlatformUtil.localAddress())[0] + ':8002';
    // }
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
    Log.w(await PlatformUtil.localAddress());
    Log.e(info);
    // 发送消息
    socket.send(info.toString());
    // 将消息添加到本地列表
    children.add(messageItem(
      info,
      true,
    ));
    scroll();
    setState(() {});
  }

  Future<void> initChat() async {
    if (widget.needCreateChatServer) {
      createChatServer();
      chatRoomUrl = 'http://127.0.0.1:7000';
    } else {
      chatRoomUrl = widget.chatServerAddress;
    }
    Log.w(chatRoomUrl);
    socket = GetSocket(chatRoomUrl + '/chat');

    Log.e('chat open');
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
    listenMessage();
    if (!isConnect && !GetPlatform.isWeb) {
      children.add(messageItem(
        MessageTextInfo(content: '加入失败!'),
        false,
      ));
    }
    if (widget.needCreateChatServer) {
      children.add(messageItem(
        MessageTextInfo(
          content: '当前窗口可通过以下url加入，也可以使用浏览器(推荐chrome)直接打开以下url，'
              '只有同局域网下的设备能打开喔~',
        ),
        false,
      ));
      List<String> addreses = await PlatformUtil.localAddress();
      if (addreses.isEmpty) {
        children.add(messageItem(
          MessageTextInfo(content: '未发现局域网IP'),
          false,
        ));
      } else
        for (String address in addreses) {
          if (address.startsWith('10.')) {
            continue;
          }
          children.add(messageItem(
            MessageTextInfo(content: 'http://$address:7000'),
            false,
          ));
        }
    } else {
      children.add(messageItem(
        MessageTextInfo(content: '已加入$chatRoomUrl'),
        false,
      ));
    }
    if (!GetPlatform.isWeb) {
      ShelfStatic.start();
    }
    setState(() {});
  }

  void listenMessage() {
    socket.onMessage((message) {
      print('服务端的消息 - $message');
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
      children.add(messageItem(
        messageInfo,
        false,
      ));
      scroll();
      setState(() {});
    });
  }

  void getHistoryMsg() {
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
    MessageTextInfo info = MessageTextInfo(
      content: controller.text,
      msgType: 'text',
    );
    socket.send(info.toString());
    children.add(messageItem(
      info,
      true,
    ));
    setState(() {});
    controller.clear();
    scroll();
  }
}
