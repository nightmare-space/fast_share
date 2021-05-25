import 'dart:convert';
import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_share/pages/model/message_info_factory.dart';
import 'package:speed_share/themes/default_theme_data.dart';
import 'package:speed_share/utils/chat_server.dart';

import 'item/message_item_factory.dart';
import 'model/model.dart';

enum MsgFileType {
  img,
  text,
  video,
}

class Message {
  final bool sendByUser;
  final String data;
  final MsgFileType fileType;
  String img;
  Message(this.sendByUser, this.data, this.fileType, {this.img});
}

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
  @override
  void initState() {
    super.initState();
    initChat();
  }

  Future<void> initChat() async {
    String url;
    if (widget.needCreateChatServer) {
      await createChatServer();
      url = 'http://127.0.0.1:7000/chat';
    } else {
      url = widget.chatServerAddress;
    }
    socket = GetSocket(url);
    socket.onOpen(() {});
    await socket.connect();
    socket.onMessage((message) {
      print('服务端的消息 - $message');
      if (message == '') {
        return;
      }
      Map<String, dynamic> map;
      try {
        map = jsonDecode(message);
      } catch (e) {
        return;
      }
      MessageBaseInfo messageInfo = MessageInfoFactory.fromJson(map);
      print(messageInfo.runtimeType);
      children.add(messageItem(messageInfo, false));
      scroll();
      setState(() {});
    });
  }

  Future<void> scroll() async {
    await Future.delayed(Duration(milliseconds: 100));
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    socket.close();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void sendTextMsg() {
    setState(() {});
    MessageTextInfo info = MessageTextInfo(
      content: controller.text,
      msgType: 'text',
    );
    socket.send(info.toString());
    children.add(messageItem(info, true));
    controller.clear();
    scroll();
    Future.delayed(Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
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
                              String filePath = await FileManager.chooseFile(
                                context: context,
                                pickPath: '/storage/emulated/0',
                              );
                              print(filePath);
                              if (filePath == null) {
                                return;
                              }
                              String url = filePath.replaceAll(
                                '/storage/emulated/0',
                                'http://192.168.210.177:8002/',
                              );
                              print(url);
                              String msgType = '';
                              if (filePath.isVideoFileName) {
                                msgType = 'video';
                              } else if (filePath.isImageFileName) {
                                msgType = 'img';
                              }
                              print('msgType $msgType');
                              // return;
                              MessageBaseInfo info =
                                  MessageInfoFactory.fromJson({
                                'url': url,
                                'msgType': msgType,
                              });
                              children.add(messageItem(info, true));
                              scroll();
                              setState(() {});
                              socket.send(info.toString());
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
}
