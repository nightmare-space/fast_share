import 'dart:io';

import 'package:global_repository/global_repository.dart';
import 'package:speed_share/utils/shelf/static_handler.dart';
import 'package:path/path.dart'as p;
import 'package:shelf/shelf_io.dart' as io;

void Function(Null arg) serverFileFunc;

class ServerUtil {
  // 用shelf部署一个路径的文件
  static serveFile(String path, int port) {
    Log.e('部署 path -> $path');
    String filePath = path.replaceAll('\\', '/');
    filePath = filePath.replaceAll(RegExp('^[A-Z]:'), '');
    filePath = filePath.replaceAll(RegExp('^/'), '');
    // 部署文件
    String url = p.toUri(filePath).toString();
    Log.e('部署 url -> $url');
    var handler = createFileHandler(path, url: url);
    serverFileFunc = (_) {
      io.serve(
        handler,
        InternetAddress.anyIPv4,
        port,
        shared: true,
      );
    };

    serverFileFunc(null);
    // final list =
    //     List.generate(Platform.numberOfProcessors - 1, (index) => null);
    // for (var item in list) {
    //   Isolate.spawn(serverFileFunc, null);
    // }
  }
}
