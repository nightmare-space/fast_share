import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart' hide Response;
import 'package:global_repository/global_repository.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/config/config.dart';
import 'package:file_manager_view/file_manager_view.dart' as f;
import 'package:speed_share/utils/utils.dart';

var app = Router();
final corsHeader = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': '*',
  'Access-Control-Allow-Methods': '*',
  'Access-Control-Allow-Credentials': 'true',
};

class Server {
  // 启动消息服务端
  static Future<int> start() async {
    ChatController controller = Get.find();
    SettingController settingController = Get.find();
    app.post('/', (Request request) async {
      corsHeader[HttpHeaders.contentTypeHeader] = ContentType.text.toString();
      Map<String, dynamic> data = jsonDecode(await request.readAsString());
      controller.handleMessage(data);
      // 这儿应该返回本机信息
      return Response.ok(
        "success",
        headers: corsHeader,
      );
    });
    app.get('/check_token', (Request request) {
      // Log.d('check_token call');
      return Response.ok('success', headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Allow-Methods': '*',
        'Access-Control-Allow-Credentials': 'true',
      });
    });
    app.post('/file_upload', (Request request) async {
      // return Response.ok(
      //   "success",
      //   headers: corsHeader,
      // );
      Log.w(request.headers);
      String? fileName = request.headers['filename'];
      if (fileName != null) {
        fileName = utf8.decode(base64Decode(fileName));
        SettingController settingController = Get.find();
        String? downPath = settingController.savePath;
        RandomAccessFile randomAccessFile = await File(getSafePath('$downPath/$fileName')).open(
          mode: FileMode.write,
        );
        int? fullLength = int.tryParse(request.headers['content-length']!);
        Log.d('fullLength -> $fullLength');
        Completer<bool> lock = Completer();
        // 已经下载的字节长度
        int count = 0;
        DownloadInfo info = DownloadInfo();
        DownloadController downloadController = Get.find();
        final blob = request.headers['blob'];
        downloadController.progress[blob] = info;
        request.read().listen(
          (event) async {
            count += event.length;
            // Log.d(event);
            // dateBytes.addAll(event);
            // progressCall?.call(
            //   dateBytes.length / request.headers.contentLength,
            //   dateBytes.length,
            // );
            randomAccessFile.writeFromSync(event);
            double progress = count / fullLength!;

            info.count = count;
            info.progress = progress;
            downloadController.update();
            if (progress == 1.0) {
              lock.complete(true);
            }
          },
          onDone: () {},
        );
        await lock.future;
        randomAccessFile.close();
        Log.v('success');
      }
      return Response.ok(
        "success",
        headers: corsHeader,
      );
    });
    // 给web用的接口
    // 用来轮询新的消息
    app.get('/message', (Request request) {
      if (controller.messageWebCache.isNotEmpty) {
        return Response.ok(
          jsonEncode(controller.messageWebCache.removeAt(0)),
          headers: corsHeader,
        );
      }
      return Response.ok(
        '',
        headers: corsHeader,
      );
    });
    // 返回速享网页的handler
    var webHandler = createStaticHandler(
      RuntimeEnvir.filesPath,
      listDirectories: true,
      defaultDocument: 'index.html',
    );
    app.mount('/', (r) {
      // `http://192.168.0.103:12000/sdcard/`的形式，说明是想要访问文件
      if (r.requestedUri.path.startsWith('/sdcard')||f.Server.routes.contains(r.requestedUri.path)) {
        if (!settingController.enableWebServer) {
          return Response.ok(
            '请先去速享客户端中开启WebServer',
            headers: {
              ...corsHeader,
              HttpHeaders.contentTypeHeader: 'text/plain',
            },
          );
        }
        try {
          return f.Server.getFileServerHandler().call(r);
        } catch (e) {
          return Response.notFound(
            e.toString(),
            headers: {
              ...corsHeader,
              HttpHeaders.contentTypeHeader: 'text/plain',
            },
          );
        }
      } else {
        // `http://192.168.0.103:12000/`的形式，说明是想要打开速享网页端
        return webHandler(r);
      }
    });
    int port = (await getSafePort(
      Config.chatPortRangeStart,
      Config.chatPortRangeEnd,
    ))!;
    // 用来解决前端的跨域
    final handler = const Pipeline().addMiddleware((innerHandler) {
      return (request) async {
        final response = await innerHandler(request);
        // Log.w(request.headers);
        // Log.i(request.requestedUri);
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: corsHeader);
        }
        return response;
      };
    }).addHandler(app);
    // ignore: unused_local_variable
    HttpServer server = await io.serve(
      handler,
      InternetAddress.anyIPv4,
      port,
      shared: true,
    );
    return port;
  }
}
