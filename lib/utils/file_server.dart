import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:mime/mime.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'path_util.dart';

/// 一个接收文件的服务端
/// Create by Nightmare at 2021/11/21
/// 这个被遗弃了 用的 chat_server_v2代替
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
    } else if (request.uri.path != '/file_upload') {
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
    } else if (request.uri.path == '/file_upload') {
      Log.w(request.headers);
      int count = 0;
      String fileName = request.headers.value('filename');
      final blob = request.headers.value('blob');
      if (fileName != null) {
        Log.w(fileName);
        fileName = utf8.decode(base64Decode(fileName));
        SettingController settingController = Get.find();
        String downPath = settingController.savePath;
        RandomAccessFile randomAccessFile = await File(getSafePath('$downPath/$fileName')).open(
          mode: FileMode.write,
        );

        DownloadInfo info = DownloadInfo();
        DownloadController downloadController = Get.find();
        downloadController.progress[blob] = info;
        await for (var data in request) {
          count += data.length;
          info.count = count;
          info.progress = count / request.headers.contentLength;
          downloadController.update();
          await randomAccessFile.writeFrom(data);
          // Log.w(dateBytes.length / request.headers.contentLength);
        }
        randomAccessFile.close();
        Log.v('success');
      }
    } else {
      // Log.w(request.headers);
      // List<int> dateBytes = [];
      // await for (var data in request) {
      //   dateBytes.addAll(data);
      //   progressCall?.call(
      //     dateBytes.length / request.headers.contentLength,
      //     dateBytes.length,
      //   );
      //   Log.v(
      //       'dateBytes.length ${dateBytes.length} request.headers.contentLength -> ${request.headers.contentLength}');
      //   Log.w(dateBytes.length / request.headers.contentLength);
      // }
      // String boundary = request.headers.contentType.parameters['boundary'];
      // final transformer = MimeMultipartTransformer(boundary);
      // final bodyStream = Stream.fromIterable([dateBytes]);
      // final parts = await transformer.bind(bodyStream).toList();
      // Directory('/sdcard/SpeedShare').createSync(recursive: true);
      // for (var part in parts) {
      //   Log.v(part.headers);
      //   final contentDisposition = part.headers['content-disposition'];
      //   Log.v('contentDisposition -> $contentDisposition');
      //   final fimename = RegExp(r'filename="([^"]*)"')
      //       .firstMatch(contentDisposition)
      //       .group(1);
      //   final content = await part.toList();
      //   File(getSafePath('/sdcard/SpeedShare/$fimename'))
      //       .writeAsBytesSync(content[0]);
      // }
      // Log.v('success');
    }
    request.response.close();
  });
}
// void main() {
//   Log.d('test');
//   startFileServer(30000);
// }
