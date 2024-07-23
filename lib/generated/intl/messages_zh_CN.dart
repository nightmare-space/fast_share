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

  static String m2(deviceName) => "点击即可访问${deviceName}的所有文件";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutSpeedShare": MessageLookupByLibrary.simpleMessage("关于速享"),
        "allDevices": MessageLookupByLibrary.simpleMessage("全部设备"),
        "androidSAFTips": MessageLookupByLibrary.simpleMessage(
            "安卓SAF架构会导致从系统文件夹选择文件总是会拷贝一份，如果使用速享自带文件管理器选择，则不会增加缓存大小"),
        "apk": MessageLookupByLibrary.simpleMessage("安装包"),
        "appName": MessageLookupByLibrary.simpleMessage("速享"),
        "autoDownload": MessageLookupByLibrary.simpleMessage("自动下载"),
        "backAgainTip": MessageLookupByLibrary.simpleMessage("再次返回退出APP~"),
        "cacheCleaned": MessageLookupByLibrary.simpleMessage("缓存已清理"),
        "cacheSize": m0,
        "camera": MessageLookupByLibrary.simpleMessage("拍照"),
        "changeLog": MessageLookupByLibrary.simpleMessage("更新日志"),
        "chatWindow": MessageLookupByLibrary.simpleMessage("消息窗口"),
        "chatWindowNotice":
            MessageLookupByLibrary.simpleMessage("当前没有任何消息，点击进入到消息列表"),
        "classifyTips":
            MessageLookupByLibrary.simpleMessage("注意，文件分类开启后会自动整理下载路径的所有文件"),
        "clearCache": MessageLookupByLibrary.simpleMessage("缓存清理"),
        "clearSuccess": MessageLookupByLibrary.simpleMessage("清理成功"),
        "clipboard": MessageLookupByLibrary.simpleMessage("剪切板"),
        "clipboardCopy": MessageLookupByLibrary.simpleMessage("的剪切板已复制"),
        "clipboardshare": MessageLookupByLibrary.simpleMessage("剪切板共享"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "common": MessageLookupByLibrary.simpleMessage("常规"),
        "connected": MessageLookupByLibrary.simpleMessage("已连接"),
        "copyed": MessageLookupByLibrary.simpleMessage("链接已复制"),
        "curCacheSize": MessageLookupByLibrary.simpleMessage("当前缓存大小"),
        "currenVersion": MessageLookupByLibrary.simpleMessage("当前版本"),
        "currentRoom": MessageLookupByLibrary.simpleMessage("聊天房间"),
        "developer": MessageLookupByLibrary.simpleMessage("开发者"),
        "device": MessageLookupByLibrary.simpleMessage("设备"),
        "directory": MessageLookupByLibrary.simpleMessage("文件夹"),
        "disconnected": MessageLookupByLibrary.simpleMessage("未连接"),
        "doc": MessageLookupByLibrary.simpleMessage("文档"),
        "downlaodPath": MessageLookupByLibrary.simpleMessage("下载路径"),
        "downloadTip":
            MessageLookupByLibrary.simpleMessage("速享还支持Windows、macOS、Linux"),
        "dropFileTip": MessageLookupByLibrary.simpleMessage("释放以分享文件到共享窗口~"),
        "empty": MessageLookupByLibrary.simpleMessage("空"),
        "enableFileClassification":
            MessageLookupByLibrary.simpleMessage("开启文件分类"),
        "enableWebServer": MessageLookupByLibrary.simpleMessage("开启Web服务器"),
        "enableWebServerTips": MessageLookupByLibrary.simpleMessage(
            "开启后，局域网设备可通过以下地址访问到本机设备的所有文件"),
        "exceptionOrcur": MessageLookupByLibrary.simpleMessage("发生异常"),
        "export": MessageLookupByLibrary.simpleMessage("导出"),
        "fileDownloadSuccess": MessageLookupByLibrary.simpleMessage("下载完成了哦"),
        "fileIsDownloading": MessageLookupByLibrary.simpleMessage("文件正在下载"),
        "fileManager": MessageLookupByLibrary.simpleMessage("文件管理"),
        "fileManagerLocal": MessageLookupByLibrary.simpleMessage("文件管理(本地)"),
        "fileQRCode": MessageLookupByLibrary.simpleMessage("文件二维码"),
        "fileType": MessageLookupByLibrary.simpleMessage("文件相关"),
        "headerNotice": m1,
        "home": MessageLookupByLibrary.simpleMessage("首页"),
        "image": MessageLookupByLibrary.simpleMessage("图片"),
        "inlineManager": MessageLookupByLibrary.simpleMessage("内部管理器"),
        "inlineManagerTips":
            MessageLookupByLibrary.simpleMessage("点击将调用自实现的文件选择器"),
        "inputAddressTip": MessageLookupByLibrary.simpleMessage("请输入文件共享窗口地址"),
        "inputConnect": MessageLookupByLibrary.simpleMessage("输入连接"),
        "join": MessageLookupByLibrary.simpleMessage("加入"),
        "joinQQGroup": MessageLookupByLibrary.simpleMessage("加入交流反馈群"),
        "lang": MessageLookupByLibrary.simpleMessage("语言"),
        "log": MessageLookupByLibrary.simpleMessage("日志"),
        "messageNote": MessageLookupByLibrary.simpleMessage("收到消息振动提醒"),
        "music": MessageLookupByLibrary.simpleMessage("音乐"),
        "needWSTip":
            MessageLookupByLibrary.simpleMessage("请先去速享客户端中开启WebServer"),
        "new_line": MessageLookupByLibrary.simpleMessage("换行"),
        "nightmare": MessageLookupByLibrary.simpleMessage("梦魇兽"),
        "noIPFound": MessageLookupByLibrary.simpleMessage("未检测到可上传IP"),
        "notifyBroswerTip": MessageLookupByLibrary.simpleMessage("已通知浏览器上传文件"),
        "open": MessageLookupByLibrary.simpleMessage("打开"),
        "openQQFail": MessageLookupByLibrary.simpleMessage("唤起QQ失败，请检查是否安装"),
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
        "select": MessageLookupByLibrary.simpleMessage("选择"),
        "sendFile": MessageLookupByLibrary.simpleMessage("发送文件"),
        "setting": MessageLookupByLibrary.simpleMessage("设置"),
        "shareFileFailed": MessageLookupByLibrary.simpleMessage("文件分享失败"),
        "systemManager": MessageLookupByLibrary.simpleMessage("系统管理器"),
        "systemManagerTips":
            MessageLookupByLibrary.simpleMessage("点击将会调用系统的文件选择器"),
        "tapToViewFile": m2,
        "theTermsOfService": MessageLookupByLibrary.simpleMessage("服务条款"),
        "ui": MessageLookupByLibrary.simpleMessage("UI设计师"),
        "unknownFile": MessageLookupByLibrary.simpleMessage("未知文件"),
        "uploadFile": MessageLookupByLibrary.simpleMessage("上传文件"),
        "video": MessageLookupByLibrary.simpleMessage("视频"),
        "vipTips": MessageLookupByLibrary.simpleMessage("这个功能需要会员才能使用哦"),
        "zip": MessageLookupByLibrary.simpleMessage("压缩包")
      };
}
