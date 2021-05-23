import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';

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
            Text('预留,之后可能有更改路径等'),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     '启动类型',
            //     style: Theme.of(context).textTheme.headline6.copyWith(
            //           color: Theme.of(context).accentColor,
            //         ),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'http_server',
            //       style: Theme.of(context).textTheme.subtitle2,
            //     ),
            //     Radio<ServerType>(
            //       value: ServerType.http_server,
            //       groupValue: serverType,
            //       onChanged: onChanged,
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'shelf_static',
            //       style: Theme.of(context).textTheme.subtitle2,
            //     ),
            //     Radio<ServerType>(
            //       value: ServerType.shelf_static,
            //       groupValue: serverType,
            //       onChanged: onChanged,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
