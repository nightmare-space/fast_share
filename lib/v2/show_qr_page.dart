import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowQRPage extends StatefulWidget {
  const ShowQRPage({Key key, this.port}) : super(key: key);
  final int port;

  @override
  State<ShowQRPage> createState() => _ShowQRPageState();
}

class _ShowQRPageState extends State<ShowQRPage> {
  List<String> address = [];
  @override
  void initState() {
    super.initState();
    PlatformUtil.localAddress().then((value) {
      address = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(100.w),
      child: Center(
        child: PageView.builder(
          itemCount: address.length,
          itemBuilder: (c, i) {
    Log.i('http://' + address[i] + ':' + widget.port.toString());
            return Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: Colors.white,
              ),
              child: QrImage(
                data: 'http://' + address[i] + ':' + widget.port.toString(),
                version: QrVersions.auto,
                size: 240.w,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
            );
          },
        ),
      ),
    );
  }
}
