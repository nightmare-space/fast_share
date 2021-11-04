import 'dart:ui';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/config/assets.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/global/global.dart';
import 'package:speed_share/global/widget/pop_button.dart';
import 'package:speed_share/themes/app_colors.dart';
import 'package:speed_share/utils/chat_server.dart';
import 'item/message_item_factory.dart';
import 'model/model.dart';

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
    controller.initChat(
      widget.needCreateChatServer,
      widget.chatServerAddress,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              controller.focusNode.unfocus();
            },
            child: GetBuilder<ChatController>(builder: (context) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  0.w,
                  kToolbarHeight + 20.w,
                  0.w,
                  120.w,
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
          Align(
            alignment: Alignment.topCenter,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8.0,
                  sigmaY: 8.0,
                ),
                child: Container(
                  height: kToolbarHeight + 20.w,
                  color: AppColors.background.withOpacity(0.4),
                  child: AppBar(
                    title: Text(
                      '文件共享',
                      style: TextStyle(
                        color: AppColors.fontColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.w,
                      ),
                    ),
                    leading: PopButton(),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8.0,
                  sigmaY: 8.0,
                ),
                child: SizedBox(
                  height: 120.w,
                  child: sendMsgContainer(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Material sendMsgContainer(BuildContext context) {
    return Material(
      color: AppColors.surface.withOpacity(0.8),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.w),
        topRight: Radius.circular(12.w),
      ),
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (GetPlatform.isAndroid)
                    SizedBox(
                      height: 32.w,
                      child: Transform(
                        transform: Matrix4.identity()..translate(0.0, -4.0.w),
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
                    height: 32.w,
                    child: Transform(
                      transform: Matrix4.identity()..translate(0.0, -4.0.w),
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
                    height: 32.w,
                    child: Transform(
                      transform: Matrix4.identity()..translate(0.0, -4.w),
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
                    width: 16.w,
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
