import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:speed_share/config/config.dart';

class ShelfStatic {
  static Future<void> start() async {
    var handler = createStaticHandler('/sdcard', listDirectories: true);

    io.serve(
      handler,
      '0.0.0.0',
      Config.shelfPort,
    );
  }

  static void close() {
    // requestServer.close();
  }
}
