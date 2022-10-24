import 'package:flutter/material.dart';

export 'main.dart';
export 'global/global.dart';
export 'config/config.dart';

void Function() sendDirImpl;

String singleFileDownloadHtml = '''
''';

Widget personHeader;
/// 如果您介意个人付费版，可以直接编译开源项目，可以获得所有权限
bool isVIP = true;
