import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/routes/app_pages.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/themes/app_colors.dart';

class JoinChat extends StatefulWidget {
  const JoinChat({Key key}) : super(key: key);

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
          height: 200.w,
          width: 300.w,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 4.w,
                ),
                Text(
                  '请输入文件共享窗口地址',
                  style: TextStyle(
                    color: AppColors.fontColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.w,
                  ),
                ),
                SizedBox(
                  height: 16.w,
                ),
                TextField(
                  controller: controller,
                  onSubmitted: (_) {
                    joinChat();
                  },
                  decoration: InputDecoration(
                    fillColor: const Color(0xfff0f0f0),
                    helperText: '这个地址在创建窗口的时候会提示',
                    hintText: '请输入共享窗口的URL',
                    hintStyle: TextStyle(
                      fontSize: 12.w,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.w,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      joinChat();
                    },
                    child: const Text(
                      '加入',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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

  void joinChat() {
    if (controller.text.isEmpty) {
      showToast('URL不能为空');
      return;
    }
    String url = controller.text;
    if (!url.startsWith('http://')) {
      url = 'http://' + url;
    }
    if (!url.endsWith(':${Config.chatPortRangeStart}')) {
      url = url + ':${Config.chatPortRangeStart}';
    }
    Get.back();
    Get.toNamed(
      '${Routes.chat}?needCreateChatServer=false&chatServerAddress=$url',
    );
  }
}
