import 'dart:io';

import 'package:get/get.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:speed_share/config/config.dart';

bool _started = false;

class ShelfStatic {
  static Future<void> start() async {
    if (_started) {
      return;
    }
    String home = '';
    if (GetPlatform.isDesktop) {
      home = '/Users/' + Platform.environment['USER'];
    } else {
      home = '/sdcard/';
    }
    var handler = createStaticHandler(home, listDirectories: true);
    io.serve(
      handler,
      '0.0.0.0',
      Config.shelfPort,
      shared: true,
    );
    _started = true;
  }

  static void close() {}
}
