import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/routes/app_pages.dart';

class JoinChat extends StatefulWidget {
  @override
  _JoinChatState createState() => _JoinChatState();
}

class _JoinChatState extends State<JoinChat> {
  TextEditingController controller = TextEditingController(
    text: '',
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
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 180,
          width: 260,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '请输入文件共享窗口地址',
                  style: TextStyle(
                    color: Colors.black,
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
                    hintText: '请输入共享窗口的URL',
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      if (controller.text.isEmpty) {
                        showToast('URL不能为空');
                        return;
                      }
                      Get.back();
                      Get.toNamed(
                        '${Routes.chat}?needCreateChatServer=false&chatServerAddress=${controller.text}',
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
