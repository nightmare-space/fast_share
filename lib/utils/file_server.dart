/**
 * 一个接收文件的服务端
 * Create by Nightmare at 2021/11/21
 */
import 'dart:io';

import 'package:global_repository/global_repository.dart';
import 'package:mime/mime.dart';

import 'path_util.dart';

void Function(double pro, int count) progressCall;
Future<void> startFileServer(int port) async {
  var server = await HttpServer.bind(
    '0.0.0.0',
    port,
    shared: true,
  );
  server.listen((request) async {
    request.response
      ..headers.add('Access-Control-Allow-Origin', '*')
      ..headers.add('Access-Control-Allow-Headers', '*')
      ..headers.add('Access-Control-Allow-Methods', '*')
      ..headers.add('Access-Control-Allow-Credentials', 'true')
      ..statusCode = HttpStatus.ok;
    if (request.uri.path == '/check_token') {
      request.response.write('web token access');
    } else if (request.uri.path != '/fileupload') {
      request.response
        ..headers.contentType = ContentType.html
        ..write('''<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<body>
    <form method="post" action="/fileupload" enctype="multipart/form-data">
        <input type="file" name="fileupload">
        <br>
        <button type="submit">UploadFile</button>
    </form>
</body>
</html>''');
    } else {
      Log.w(request.headers);
      List<int> dateBytes = [];
      await for (var data in request) {
        dateBytes.addAll(data);
        progressCall?.call(
          dateBytes.length / request.headers.contentLength,
          dateBytes.length,
        );
        print(
            'dateBytes.length ${dateBytes.length} request.headers.contentLength -> ${request.headers.contentLength}');
        Log.w(dateBytes.length / request.headers.contentLength);
      }
      String boundary = request.headers.contentType.parameters['boundary'];
      final transformer = MimeMultipartTransformer(boundary);
      final bodyStream = Stream.fromIterable([dateBytes]);
      final parts = await transformer.bind(bodyStream).toList();

      for (var part in parts) {
        // print(part.headers);
        final contentDisposition = part.headers['content-disposition'];
        print('contentDisposition -> $contentDisposition');
        final fimename = RegExp(r'filename="([^"]*)"')
            .firstMatch(contentDisposition)
            .group(1);
        final content = await part.toList();
        File(getSafePath('/sdcard/SpeedShare/$fimename'))
            .writeAsBytesSync(content[0]);
      }
      print('success');
    }
    request.response.close();
  });
}
