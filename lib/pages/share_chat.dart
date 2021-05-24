import 'dart:convert';
import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_share/themes/default_theme_data.dart';
import 'package:speed_share/utils/chat_server.dart';

enum SendFileType {
  img,
  text,
  video,
}

class Message {
  final bool sendByUser;
  final String data;
  final SendFileType fileType;
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
  List<Message> msgs = [];
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

      if (!map.containsKey('data')) {
        return;
      }
      String content = map['data'];
      if (map.containsKey('img')) {
        msgs.add(Message(false, '', SendFileType.img, img: map['img']));
      } else {
        msgs.add(Message(false, content, SendFileType.text));
      }
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
    super.dispose();
  }

  void sendTextMsg() {
    msgs.add(Message(true, controller.text, SendFileType.text));
    setState(() {});
    socket.send(jsonEncode({
      'type': '123',
      'data': controller.text,
    }));
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: msgs.length,
              itemBuilder: (c, i) {
                Message msg = msgs[i];
                if (msg.fileType == SendFileType.img) {
                  return Align(
                    alignment: msg.sendByUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          msg.img,
                          width: 100,
                        ),
                      ),
                    ),
                  );
                }
                return Align(
                  alignment: msg.sendByUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Theme(
                        data: ThemeData(
                          textSelectionTheme: TextSelectionThemeData(
                            cursorColor: Colors.red,
                            selectionColor: Color(0xffede8f8),
                          ),
                        ),
                        child: SelectableText(
                          msg.data,
                          cursorColor: Color(0xffede8f8),
                        ),
                      ),
                    ),
                  ),
                );
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
                            filePath = filePath.replaceAll(
                              '/storage/emulated/0',
                              'http://192.168.149.32:8002/',
                            );
                            print(filePath);
                            msgs.add(
                              Message(
                                true,
                                '',
                                SendFileType.img,
                                img: filePath,
                              ),
                            );
                            setState(() {});
                            socket.send(jsonEncode({
                              'type': '',
                              'data': controller.text,
                              'img': filePath,
                            }));
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
    );
  }
}
