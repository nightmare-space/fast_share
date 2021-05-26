import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_share/app/routes/app_pages.dart';
import 'package:speed_share/pages/share_chat.dart';
import 'package:speed_share/themes/default_theme_data.dart';

class JoinChat extends StatefulWidget {
  @override
  _JoinChatState createState() => _JoinChatState();
}

class _JoinChatState extends State<JoinChat> {
  TextEditingController controller = TextEditingController(
    text: 'http://',
  );
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: SizedBox(
          height: 180,
          width: 260,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '请输入文件共享窗口地址',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    fillColor: Color(0xfff0f0f0),
                    helperText: '这个地址在创建窗口的时候会提示',
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed(
                        Routes.chat +
                            '?needCreateChatServer=false&chatServerAddress=${controller.text + '/chat'}',
                      );
                      // Get.to(ShareChat(
                      //   needCreateChatServer: false,
                      //   chatServerAddress: controller.text + '/chat',
                      // ));
                    },
                    child: Text(
                      '加入',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
