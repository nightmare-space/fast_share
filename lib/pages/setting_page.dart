import 'package:flutter/material.dart';
import 'package:speed_share/config/candy_colors.dart';
import 'package:speed_share/config/dimens.dart';

enum ServerType {
  shelf_static,
  http_server,
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  ServerType serverType = ServerType.http_server;
  void onChanged(ServerType serverType) {
    this.serverType = serverType;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.gap_dp8,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '启动类型',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Theme.of(context).accentColor,
                    ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'http_server',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Radio<ServerType>(
                  value: ServerType.http_server,
                  groupValue: serverType,
                  onChanged: onChanged,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'shelf_static',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Radio<ServerType>(
                  value: ServerType.shelf_static,
                  groupValue: serverType,
                  onChanged: onChanged,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: Dimens.gap_dp4,
                  height: Dimens.gap_dp24,
                  color: CandyColors.candyPink,
                ),
                SizedBox(
                  width: Dimens.gap_dp8,
                ),
                Expanded(
                  child: Text(
                    '第一种可提供断点续传，可在线浏览视频，但对于内存较大(大于2GB)文件的下载与视频播放会存在内存占用过高的问题',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: Dimens.gap_dp4,
                  height: Dimens.gap_dp24,
                  color: CandyColors.candyPink,
                ),
                SizedBox(
                  width: Dimens.gap_dp8,
                ),
                Expanded(
                  child: Text(
                    '第二种对于视频的在线非常不友好，但大文件的下载不会出现内存占用过高的问题',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
