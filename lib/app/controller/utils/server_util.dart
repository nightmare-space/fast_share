import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:speed_share/speed_share.dart';
import 'package:speed_share/utils/ext_util.dart';
import 'package:speed_share/utils/shelf/static_handler.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf_io.dart' as io;

void Function(Null arg) serverFileFunc;

class IsolateArg {
  int port;
}

final corsHeader = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': '*',
  'Access-Control-Allow-Methods': '*',
  'Access-Control-Allow-Credentials': 'true',
};

// 用来部署单个文件
class ServerUtil {
  // 用shelf部署一个路径的文件
  static serveFile(String path, int port) async {
    Log.e('部署 path -> $path');
    String filePath = path.replaceAll('\\', '/');
    filePath = filePath.replaceAll(RegExp('^[A-Z]:'), '');
    filePath = filePath.replaceAll(RegExp('^/'), '');
    // 部署文件
    String url = p.toUri(filePath).toString();
    Log.e('部署 url -> $url');
    var handler = createFileHandler(path, url: url);
    // serverFileFunc = (_) {
    //   io.serve(
    //     handler,
    //     InternetAddress.anyIPv4,
    //     port,
    //     shared: true,
    //   );
    // };
    io.serve(
      handler,
      InternetAddress.anyIPv4,
      port,
      shared: true,
    );

    // serverFileFunc(null);
    // final list =
    //     List.generate(Platform.numberOfProcessors - 1, (index) => null);
    // for (var item in list) {
    //   Isolate.spawn(serverFileFunc, null);
    // }
  }
}

String getIconFromPath(String path) {
  if (path.isVideo) {
    return 'video';
  } else if (path.isPdf) {
    return 'pdf';
  } else if (path.isDoc) {
    return 'doc';
  } else if (path.isZip) {
    return 'zip';
  } else if (path.isAudio) {
    return 'mp3';
  } else if (path.isImg) {
    return 'other';
  }
  return 'other';
}
