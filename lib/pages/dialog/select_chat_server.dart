import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_share/pages/share_chat.dart';

import 'join_chat.dart';

/// 返回`bool`。true代表创建新的聊天服务器，false代表加入现有的服务器
class SelectChatServer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: SizedBox(
          height: 80,
          width: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                  Get.to(ShareChat(
                    needCreateChatServer: true,
                  ));
                },
                child: SizedBox(
                  height: 40,
                  child: Align(
                    child: Text(
                      '创建新的共享窗口',
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                  Get.dialog(JoinChat());
                },
                child: SizedBox(
                  height: 40,
                  child: Align(
                    child: Text('加入已创建的共享窗口'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}