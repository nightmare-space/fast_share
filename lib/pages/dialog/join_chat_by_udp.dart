import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/routes/app_pages.dart';

class JoinChatByUdp extends StatefulWidget {
  final String addr;

  const JoinChatByUdp({Key key, this.addr}) : super(key: key);
  @override
  _JoinChatByUdpState createState() => _JoinChatByUdpState();
}

class _JoinChatByUdpState extends State<JoinChatByUdp> {
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
          height: 120,
          width: 260,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '发现设备创建了窗口，是否加入',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          '取消',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.toNamed(
                            '${Routes.chat}?needCreateChatServer=false&chatServerAddress=http://${widget.addr}:7000',
                          );
                        },
                        child: Text(
                          '加入',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
