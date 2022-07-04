import 'dart:convert';
import 'dart:io';

import 'package:file_manager_view/core/io/impl/directory_unix.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/utils.dart';
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/config/config.dart';

var app = Router();
final corsHeader = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': '*',
  'Access-Control-Allow-Methods': '*',
  'Access-Control-Allow-Credentials': 'true',
};

class Server {
  // 启动文件管理器服务端
  static Future<int> start() async {
    app.post('/', (Request request) async {
      ChatController controller = Get.find();
      corsHeader[HttpHeaders.contentTypeHeader] = ContentType.text.toString();
      Map<String,dynamic> data=jsonDecode(await request.readAsString());
      controller.cache.add(data);
      controller.handleMessage(data);
      return Response.ok(
        "success",
        headers: corsHeader,
      );
    });

    int port = await getSafePort(
      Config.chatPortRangeStart,
      Config.chatPortRangeEnd,
    );
    Log.i(port);
    // ignore: unused_local_variable
    HttpServer server = await io.serve(
      app,
      InternetAddress.anyIPv4,
      port,
      shared: true,
    );
    return port;
  }
}

Future<String> execCmd(
  String cmd, {
  bool throwException = true,
}) async {
  final List<String> args = cmd.split(' ');
  ProcessResult execResult;
  if (Platform.isWindows) {
    execResult = await Process.run(
      RuntimeEnvir.binPath + Platform.pathSeparator + args[0],
      args.sublist(1),
      environment: RuntimeEnvir.envir(),
      includeParentEnvironment: true,
      runInShell: false,
    );
  } else {
    execResult = await Process.run(
      args[0],
      args.sublist(1),
      environment: RuntimeEnvir.envir(),
      includeParentEnvironment: true,
      runInShell: false,
    );
  }
  if ('${execResult.stderr}'.isNotEmpty) {
    if (throwException) {
      Log.w('adb stderr -> ${execResult.stderr}');
      throw Exception(execResult.stderr);
    }
  }
  // Log.e('adb stdout -> ${execResult.stdout}');
  return execResult.stdout.toString().trim();
}
