import 'dart:io';

import 'package:get/get.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:speed_share/config/config.dart';

import 'shelf/virtual_directory.dart';

bool _started = false;

class ShelfStatic {
  static Future<void> start() async {
    if (_started) {
      return;
    }

    String home = '';
    if (GetPlatform.isWindows) {
      home = 'F:\\';
    } else if (GetPlatform.isDesktop) {
      home = '/Users';
    } else {
      home = '/sdcard';
    }
    // final virDirHandler = ShelfVirtualDirectory('/', showLogs: true).handler;
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
