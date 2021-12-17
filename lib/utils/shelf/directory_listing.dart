// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart' as path;
import 'package:shelf/shelf.dart';

String _getHeader(String sanitizedHeading) => '''<!DOCTYPE html>
<html>
<head>
  <title>Directory listing for $sanitizedHeading</title>
      <script>
        function onClick(data) {
            window.open(data)
        }
    </script>
    <style>
        button{
            margin: 0 0 0 60px;
        }
    </style>
</head>
<body>
<h1>Index of $sanitizedHeading</h1>
<table>
  <tr>
    <td>Name</td>
    <td>Last modified</td>
    <td>Size</td>
  </tr>
''';

const String _trailer = '''</table>
</body>
</html>
''';
int fileNodeCompare(FileSystemEntity e1, FileSystemEntity e2) {
  if (e1 is Directory && e2 is! Directory) {
    return -1;
  }
  if (e1 is! Directory && e2 is Directory) {
    return 1;
  }
  return e1.path.toLowerCase().compareTo(e2.path.toLowerCase());
}

Response listDirectory(String fileSystemPath, String dirPath) {
  final controller = StreamController<List<int>>();
  const encoding = Utf8Codec();
  const sanitizer = HtmlEscape();

  void add(String name, String modified, String size, bool isDir) {
    modified ??= '';
    size ??= '-';
    String button =
        isDir ? '' : '<button onclick="onClick(\'$name?download=true\')">直接下载</button>';
    var entry = '''  <tr>
    <td><a href="$name">$name</a>$button</td>
    <td>$modified</td>
    <td style="text-align: right">$size</td>
  </tr>''';
    controller.add(encoding.encode(entry));
  }

  var heading = path.relative(dirPath, from: fileSystemPath);
  if (heading == '.') {
    heading = '/';
  } else {
    heading = '/$heading/';
  }

  controller.add(encoding.encode(_getHeader(sanitizer.convert(heading))));

  // Return a sorted listing of the directory contents asynchronously.
  Directory(dirPath).list().toList()
    .then((entities) {
      entities.sort(fileNodeCompare);
      if (dirPath != '/') {
        add('../', null, null, true);
      }
      for (var entity in entities) {
        var name = path.relative(entity.path, from: dirPath);
        var stat = entity.statSync();
        bool isDir = false;
        int size = stat.size;
        String modified = stat.modified.toString();
        if (entity is Directory) {
          name += '/';
          isDir = true;
        }
        final sanitizedName = sanitizer.convert(name);
        var encodedSize = const HtmlEscape().convert(
          FileSizeUtils.getFileSize(size),
        );
        var encodedModified = const HtmlEscape().convert(modified);

        add(sanitizedName, encodedModified, encodedSize, isDir);
      }

      controller.add(encoding.encode(_trailer));
      controller.close();
    });

  return Response.ok(
    controller.stream,
    encoding: encoding,
    headers: {HttpHeaders.contentTypeHeader: 'text/html'},
  );
}
