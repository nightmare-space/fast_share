// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  static String m0(number) =>
      "${Intl.plural(number, other: '当前缓存大小${number}MB')}";

  static String m1(number) =>
      "${Intl.plural(number, zero: '当前未连接任何设备', other: '有${number}封未读邮件')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutSpeedShare": MessageLookupByLibrary.simpleMessage("关于速享"),
        "apk": MessageLookupByLibrary.simpleMessage("安装包"),
        "appName": MessageLookupByLibrary.simpleMessage("速享"),
        "autoDownload": MessageLookupByLibrary.simpleMessage("自动下载"),
        "cacheSize": m0,
        "changeLog": MessageLookupByLibrary.simpleMessage("更新日志"),
        "chatWindow": MessageLookupByLibrary.simpleMessage("消息窗口（以前点+号打开的页面）"),
        "chatWindowNotice":
            MessageLookupByLibrary.simpleMessage("当前没有任何消息，点击进入到消息列表"),
        "clearCache": MessageLookupByLibrary.simpleMessage("缓存清理"),
        "clearSuccess": MessageLookupByLibrary.simpleMessage("清理成功"),
        "clipboardshare": MessageLookupByLibrary.simpleMessage("剪切板共享"),
        "common": MessageLookupByLibrary.simpleMessage("常规"),
        "currenVersion": MessageLookupByLibrary.simpleMessage("当前版本"),
        "currentRoom": MessageLookupByLibrary.simpleMessage("聊天房间"),
        "developer": MessageLookupByLibrary.simpleMessage("开发者"),
        "directory": MessageLookupByLibrary.simpleMessage("文件夹"),
        "doc": MessageLookupByLibrary.simpleMessage("文档"),
        "downlaodPath": MessageLookupByLibrary.simpleMessage("下载路径"),
        "downloadTip":
            MessageLookupByLibrary.simpleMessage("速享还支持Windows、macOS、Linux"),
        "empty": MessageLookupByLibrary.simpleMessage("空"),
        "enableFileClassification":
            MessageLookupByLibrary.simpleMessage("开启文件分类"),
        "enbaleWebServer": MessageLookupByLibrary.simpleMessage("开启Web服务器"),
        "headerNotice": m1,
        "image": MessageLookupByLibrary.simpleMessage("图片"),
        "inputConnect": MessageLookupByLibrary.simpleMessage("输入连接"),
        "joinQQGroup": MessageLookupByLibrary.simpleMessage("加入交流反馈群"),
        "lang": MessageLookupByLibrary.simpleMessage("语言"),
        "log": MessageLookupByLibrary.simpleMessage("日志"),
        "messageNote": MessageLookupByLibrary.simpleMessage("收到消息振动提醒"),
        "music": MessageLookupByLibrary.simpleMessage("音乐"),
        "nightmare": MessageLookupByLibrary.simpleMessage("梦魇兽"),
        "openSource": MessageLookupByLibrary.simpleMessage("开源地址"),
        "otherVersion": MessageLookupByLibrary.simpleMessage("其他版本下载"),
        "privacyAgreement": MessageLookupByLibrary.simpleMessage("隐私政策"),
        "projectBoard": MessageLookupByLibrary.simpleMessage("魇系列项目面板"),
        "qrTips": MessageLookupByLibrary.simpleMessage("左右滑动切换IP地址"),
        "recentConnect": MessageLookupByLibrary.simpleMessage("最近连接"),
        "recentFile": MessageLookupByLibrary.simpleMessage("最近文件"),
        "recentImg": MessageLookupByLibrary.simpleMessage("最近图片"),
        "remoteAccessDes":
            MessageLookupByLibrary.simpleMessage("在浏览器打开以下IP地址，即可远程管理本机文件"),
        "remoteAccessFile": MessageLookupByLibrary.simpleMessage("远程访问本机文件"),
        "scan": MessageLookupByLibrary.simpleMessage("扫描二维码"),
        "setting": MessageLookupByLibrary.simpleMessage("设置"),
        "theTermsOfService": MessageLookupByLibrary.simpleMessage("服务条款"),
        "ui": MessageLookupByLibrary.simpleMessage("UI设计师"),
        "unknownFile": MessageLookupByLibrary.simpleMessage("未知文件"),
        "video": MessageLookupByLibrary.simpleMessage("视频"),
        "zip": MessageLookupByLibrary.simpleMessage("压缩包")
      };
}
