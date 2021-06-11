import 'dart:io';

import 'package:global_repository/global_repository.dart';

// 可以接收一个命令，返回命令结果
class ProcessServer {
  static HttpServer requestServer;
  static Future<void> start() async {
    requestServer = await HttpServer.bind(
      InternetAddress.anyIPv4,
      8000,
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
    requestServer?.close();
  }
}

void handleMessage(HttpRequest request) {
  try {
    if (request.method == 'GET') {
      //获取到GET请求

      handleGET(request);
    } else if (request.method == 'POST') {
      handleGET(request);
      //获取到POST请求

    } else if (request.method == 'OPTIONS') {
      handleGET(request);
      //获取到POST请求

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

Future<void> handleGET(HttpRequest request) async {
  String cmdline = '';
  request.headers.forEach(
    (name, values) {
      if (name == 'cmdline') {
        cmdline = values.first;
      }
    },
  );
  print('cmdline ->$cmdline');
  // ProcessResult result = Process.runSync('sh', ['-c', cmdline]);
  // print('resultstdout -> ${result.stdout}');
  // print('resultstderr -> ${result.stderr}');
  String result = await NiProcess.exec(cmdline);
  request.response
    ..headers.add('Access-Control-Allow-Origin', '*')
    ..headers.add('Access-Control-Allow-Headers', '*')
    ..headers.add('Access-Control-Allow-Methods', '*')
    ..headers.add('Access-Control-Allow-Credentials', 'true')
    ..statusCode = HttpStatus.ok
    ..write(result)
    ..close();
}
