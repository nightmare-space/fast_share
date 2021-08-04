import 'dart:io';

import 'package:get/get.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:speed_share/config/config.dart';

import 'shelf/static_handler.dart';

bool _started = false;

class ShelfStatic {
  static Future<void> start() async {
    if (_started) {
      return;
    }

    _started = true;
    String home = '';
    if (GetPlatform.isWindows) {
      // io.serve(
      //   createStaticHandler('C:\\', listDirectories: true),
      //   '0.0.0.0',
      //   Config.shelfPort,
      //   shared: true,
      // );
      // io.serve(
      //   createStaticHandler('D:\\', listDirectories: true),
      //   '0.0.0.0',
      //   Config.shelfPort,
      //   shared: true,
      // );
      io.serve(
        createStaticHandler('E:\\', listDirectories: true),
        InternetAddress.anyIPv4,
        Config.shelfAllPort,
        shared: true,
      );
      io.serve(
        createStaticHandler('F:\\', listDirectories: true),
        InternetAddress.anyIPv4,
        Config.shelfAllPort,
        shared: true,
      );
      return;
    } else if (GetPlatform.isDesktop) {
      home = '/';
    } else {
      home = '/sdcard';
    }
    // final virDirHandler = ShelfVirtualDirectory('/', showLogs: true).handler;
    var handler = createStaticHandler(
      home,
      listDirectories: true,
    );
    HttpServer server = await io.serve(
      handler,
      InternetAddress.anyIPv4,
      Config.shelfAllPort,
      shared: true,
    );
  }

  static void close() {}
}
