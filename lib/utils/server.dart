import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:speed_share/config/config.dart';
import 'package:speed_share/utils/virtual_directory.dart';

class ServerUtil {
  ServerUtil._();
  static HttpServer requestServer;
  static Future<void> start() async {
    requestServer = await HttpServer.bind(
      InternetAddress.anyIPv4,
      Config.httpServerPort,
      shared: true,
    );
//HttpServer.bind(主机地址，端口号)
//主机地址：InternetAddress.loopbackIPv4和InternetAddress.loopbackIPv6都可以监听到
    print('监听 localhost地址，端口号为${requestServer.port}');
    //监听请求
    await for (final HttpRequest request in requestServer) {
      //监听到请求后response回复它一个Hello World!然后关闭这个请求
      handleMessage(request);
    }
  }

  static void close() {
    requestServer.close();
  }
}

void handleMessage(HttpRequest request) {
  try {
    if (request.method == 'GET') {
      //获取到GET请求
      handleGET(request);
    } else if (request.method == 'POST') {
      //获取到POST请求
      // handlePOST(request);
    } else {
      //其它的请求方法暂时不支持，回复它一个状态
      request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('对不起，不支持${request.method}方法的请求！')
        ..close();
    }
  } catch (e) {
    print('出现了一个异常，异常为：$e');
  }
  print('请求被处理了');
}

// TODO这儿还有一些问题
final Uri _servingDirectory = Uri.directory(Platform.isMacOS
    ? '/Users/nightmare/Desktop/nightmare-space/'
    : '/sdcard/');
void handleGET(HttpRequest request) {
  final VirtualDirectory staticFiles = VirtualDirectory(
    _servingDirectory.toFilePath(),
  );
  staticFiles.allowDirectoryListing = true;
  staticFiles.jailRoot = true;
  print('get 请求');
  staticFiles.serveRequest(request);
  return;
}
