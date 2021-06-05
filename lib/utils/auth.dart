import 'dart:io';

class HttpServerUtil {
  static void bindServer() {
    HttpServer.bind(InternetAddress.anyIPv4, 7001).then((server) {
      //显示服务器地址和端口
      print('Serving at ${server.address}:${server.port}');
      //通过编写HttpResponse对象让服务器响应请求
      server.listen((HttpRequest request) {
        //HttpResponse对象用于返回客户端
        print('${request.connectionInfo.remoteAddress}');
        request.response
          ..headers.contentType = ContentType('text', 'plain', charset: 'utf-8')
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..headers.add('Access-Control-Allow-Headers', '*')
          ..headers.add('Access-Control-Allow-Methods', '*')
          ..headers.add('Access-Control-Allow-Credentials', 'true')
          ..write('success')
          //结束与客户端连接
          ..close();
      });
    });
  }
}
