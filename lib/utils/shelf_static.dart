import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

class ShelfStatic {
  static Future<void> start() async {
    var handler = createStaticHandler('/sdcard', listDirectories: true);

    io.serve(handler, '0.0.0.0', 8002);
  }

  static void close() {
    // requestServer.close();
  }
}
