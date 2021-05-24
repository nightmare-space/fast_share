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
  print('request.uri ${request.requestedUri}');
  Uri uri = request.requestedUri;
  var relativePath = request.uri.toFilePath();
  if (relativePath.startsWith('/')) {
    relativePath = relativePath.substring(1);
  }
  print('relativePath $relativePath');
  var fileUri = _servingDirectory.resolve(relativePath);
  print('fileUri -> ${fileUri.toFilePath()}');
  File file;
  if (FileSystemEntity.isDirectorySync(fileUri.toFilePath())) {
    List<FileSystemEntity> list = Directory(fileUri.toFilePath()).listSync();
    StringBuffer buffer = StringBuffer();
    String files = html;
    for (FileSystemEntity fileSystemEntity in list) {
      // print("${relativePath}/${path.basename(fileSystemEntity.path)}");
      String prefix = relativePath;
      if (prefix.isNotEmpty) {
        prefix += '/';
      }
      buffer.write('''
            <tr bgcolor="#eeeeee">
                <td align="left">&nbsp;&nbsp;
                    <a href="/$prefix${path.basename(fileSystemEntity.path)}"><tt>${path.basename(fileSystemEntity.path)}/</tt></a>
                </td>
                <td align="right"><tt>&nbsp;</tt></td>
                <td align="right"><tt>Thu, 24 Dec 2020 05:58:42 GMT</tt></td>
            </tr>
        ''');
    }

    files = files.replaceAll('placeholder', buffer.toString());
    request.response
      ..headers.contentType = contentTypeForExtension('html')
      ..write(files)
      ..close();

    file = File.fromUri(fileUri.resolve("test.html"));
  } else {
    file = File.fromUri(fileUri);
  }

  var exten = path.extension(file.path);
  print('exten -> $exten');
  print('relativePath -> $relativePath');

  if (!file.existsSync()) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write('对不起，不存在改文件！')
      ..close();
  }
}

String html = '''
<!-- saved from url=(0026)http://nightmare.fun/File/ -->
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Directory Listing For [/]</title>
    <style>
        <!--h1 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:22px;} h2 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:16px;} h3 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:14px;} body {font-family:Tahoma,Arial,sans-serif;color:black;background-color:white;} b {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;} p {font-family:Tahoma,Arial,sans-serif;background:white;color:black;font-size:12px;} a {color:black;} a.name {color:black;} .line {height:1px;background-color:#525D76;border:none;}
        -->
    </style>
</head>

<body>
    <h1>Directory Listing For [/]</h1>
    <hr size="1" noshade="noshade">
    <table width="100%" cellspacing="0" cellpadding="5" align="center">
        <tbody>
            <tr>
                <td align="left">
                    <font size="+1"><strong>Filename</strong></font>
                </td>
                <td align="center">
                    <font size="+1"><strong>Size</strong></font>
                </td>
                <td align="right">
                    <font size="+1"><strong>Last Modified</strong></font>
                </td>
            </tr>
            placeholder

        </tbody>
    </table>
    <hr size="1" noshade="noshade">
    <h3>Apache Tomcat/9.0.22</h3>

</body>

</html>
''';
Map<String, ContentType> _defaultExtensionMap = {
  /* Web content */
  "html": ContentType("text", "html", charset: "utf-8"),
  "dart": ContentType("text", "html", charset: "utf-8"),
  "css": ContentType("text", "css", charset: "utf-8"),
  "js": ContentType("application", "javascript", charset: "utf-8"),
  "json": ContentType("application", "json", charset: "utf-8"),

  /* Images */
  "jpg": ContentType("image", "jpeg"),
  "jpeg": ContentType("image", "jpeg"),
  "eps": ContentType("application", "postscript"),
  "png": ContentType("image", "png"),
  "gif": ContentType("image", "gif"),
  "bmp": ContentType("image", "bmp"),
  "tiff": ContentType("image", "tiff"),
  "tif": ContentType("image", "tiff"),
  "ico": ContentType("image", "x-icon"),
  "svg": ContentType("image", "svg+xml"),

  /* Documents */
  "rtf": ContentType("application", "rtf"),
  "pdf": ContentType("application", "pdf"),
  "csv": ContentType("text", "plain", charset: "utf-8"),
  "md": ContentType("text", "plain", charset: "utf-8"),

  /* Fonts */
  "ttf": ContentType("font", "ttf"),
  "eot": ContentType("application", "vnd.ms-fontobject"),
  "woff": ContentType("font", "woff"),
  "otf": ContentType("font", "otf"),
  "mp4": ContentType("video", "mp4"),
};

final Map<String, ContentType> _extensionMap = Map.from(_defaultExtensionMap);

/// Returns a [ContentType] for a file extension.
///
/// Returns the associated content type for [extension], if one exists. Extension may have leading '.',
/// e.g. both '.jpg' and 'jpg' are valid inputs to this method.
///
/// Returns null if there is no entry for [extension]. Entries can be added with [setContentTypeForExtension].
ContentType contentTypeForExtension(String extension) {
  if (extension.startsWith(".")) {
    return _extensionMap[extension.substring(1)];
  }
  return _extensionMap[extension];
}
