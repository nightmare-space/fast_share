import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/modules/file/file_page.dart';
import 'package:speed_share/modules/personal/personal.dart';
import 'package:speed_share/modules/remote_page.dart';
import 'package:speed_share/modules/share_chat_window.dart';

import 'home_page.dart';
import 'nav.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({Key key}) : super(key: key);

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  int page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Builder(builder: (context) {
                if (GetPlatform.isWeb) {
                  return [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: const ShareChatV2(),
                      ),
                    ),
                    const SizedBox(),
                    const RemotePage(),
                    const SizedBox(),
                    const FilePage(),
                    const SizedBox(),
                  ][page];
                }
                return [
                  const HomePage(),
                  const RemotePage(),
                  const SizedBox(),
                  const FilePage(),
                  const PersonalPage(),
                ][page];
              }),
            ),
            Nav(
              value: page,
              onTap: (value) {
                page = value;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
