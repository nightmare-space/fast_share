import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/config/assets.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/utils/chat_server.dart';
import 'package:speed_share/utils/shelf/static_handler.dart';
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
  ChatController controller = Get.find();
  @override
  void initState() {
    super.initState();
    initChat();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initChat() async {
    Global().disableShowDialog();
    if (!GetPlatform.isWeb) {
      controller.addreses = await PlatformUtil.localAddress();
    }
    if (widget.needCreateChatServer) {
      // 是创建房间的一端
      createChatServer();
      UniqueKey uniqueKey = UniqueKey();
      Global().startSendBoardcast(
        uniqueKey.toString() + ' ' + controller.addreses.join(' '),
      );
      controller.chatRoomUrl = 'http://127.0.0.1:${Config.chatPort}';
    } else {
      controller.chatRoomUrl = widget.chatServerAddress;
    }
    controller.socket = GetSocket(controller.chatRoomUrl + '/chat');
    Log.v('chat open');
    controller.socket.onOpen(() {
      Log.d('chat连接成功');
      controller.isConnect = true;
    });

    try {
      await controller.socket.connect();
      await Future.delayed(Duration.zero);
    } catch (e) {
      controller.isConnect = false;
    }
    if (!controller.isConnect && !GetPlatform.isWeb) {
      // 如果连接失败并且不是 web 平台
      controller.children.add(MessageItemFactory.getMessageItem(
        MessageTextInfo(content: '加入失败!'),
        false,
      ));
      return;
    }
    if (widget.needCreateChatServer) {
      await controller.sendAddressAndQrCode();
    } else {
      controller.children.add(MessageItemFactory.getMessageItem(
        MessageTextInfo(content: '已加入${controller.chatRoomUrl}'),
        false,
      ));
      setState(() {});
    }
    // 监听消息
    controller.listenMessage();
    await Future.delayed(Duration(milliseconds: 100));
    controller.getHistoryMsg();
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
          controller.focusNode.unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: GetBuilder<ChatController>(builder: (context) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  controller: controller.scrollController,
                  itemCount: controller.children.length,
                  cacheExtent: 99999,
                  itemBuilder: (c, i) {
                    return controller.children[i];
                  },
                );
              }),
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
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (GetPlatform.isAndroid)
                    SizedBox(
                      height: 32,
                      child: Transform(
                        transform: Matrix4.identity()..translate(0.0, -4.0),
                        child: IconButton(
                          alignment: Alignment.center,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.image,
                            color: AppColors.accentColor,
                          ),
                          onPressed: () async {
                            controller.sendFileForAndroid(
                              useSystemPicker: true,
                            );
                          },
                        ),
                      ),
                    ),
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
                            controller.sendFileForAndroid();
                          }
                          if (GetPlatform.isDesktop) {
                            controller.sendFileForDesktop();
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    child: Transform(
                      transform: Matrix4.identity()..translate(0.0, -4.0),
                      child: IconButton(
                        alignment: Alignment.center,
                        padding: EdgeInsets.zero,
                        icon: SvgPicture.asset(
                          Assets.dir,
                          color: AppColors.accentColor,
                        ),
                        onPressed: () async {
                          controller.sendDir();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: controller.focusNode,
                      controller: controller.controller,
                      autofocus: false,
                      maxLines: 8,
                      minLines: 1,
                      style: TextStyle(
                        textBaseline: TextBaseline.ideographic,
                      ),
                      onSubmitted: (_) {
                        controller.sendTextMsg();
                        Future.delayed(Duration(milliseconds: 100), () {
                          controller.focusNode.requestFocus();
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
                        controller.sendTextMsg();
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
}
