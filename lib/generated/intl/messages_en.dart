// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(number) =>
      "${Intl.plural(number, other: 'Current cache size ${number}MB')}";

  static String m1(number) =>
      "${Intl.plural(number, zero: 'No devices connect', other: 'have ${number} connected')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About Speed Share"),
        "aboutSpeedShare":
            MessageLookupByLibrary.simpleMessage("About Speed Share"),
        "allDevices": MessageLookupByLibrary.simpleMessage("All Devices"),
        "androidSAFTips": MessageLookupByLibrary.simpleMessage(
            "Android SAF architecture will cause the file selected from the system folder to always be copied. If you use the SpeedShare\'s file manager to select, it will not increase the cache size"),
        "apk": MessageLookupByLibrary.simpleMessage("Apk"),
        "appName": MessageLookupByLibrary.simpleMessage("Speed Share"),
        "autoDownload": MessageLookupByLibrary.simpleMessage("Auto Download"),
        "cacheCleaned": MessageLookupByLibrary.simpleMessage("Cache Cleaned"),
        "cacheSize": m0,
        "camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "changeLog": MessageLookupByLibrary.simpleMessage("Change Log"),
        "chatWindow": MessageLookupByLibrary.simpleMessage("Chat Window"),
        "chatWindowNotice": MessageLookupByLibrary.simpleMessage(
            "Currently no messages, click to view the message list"),
        "classifyTips": MessageLookupByLibrary.simpleMessage(
            "Note, after the file classification is turned on, all files in the download path will be automatically organized"),
        "clearCache": MessageLookupByLibrary.simpleMessage("Clear Cache"),
        "clearSuccess": MessageLookupByLibrary.simpleMessage("Clear Success"),
        "clipboardshare":
            MessageLookupByLibrary.simpleMessage("Clipboard Share"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "common": MessageLookupByLibrary.simpleMessage("Common"),
        "connected": MessageLookupByLibrary.simpleMessage("Connected"),
        "curCacheSize":
            MessageLookupByLibrary.simpleMessage("Current Cache Size"),
        "currenVersion":
            MessageLookupByLibrary.simpleMessage("Current Version"),
        "currentRoom": MessageLookupByLibrary.simpleMessage("Chat Room"),
        "developer": MessageLookupByLibrary.simpleMessage("Developer"),
        "device": MessageLookupByLibrary.simpleMessage("Devices"),
        "directory": MessageLookupByLibrary.simpleMessage("Directory"),
        "disconnected": MessageLookupByLibrary.simpleMessage("Disconnected"),
        "doc": MessageLookupByLibrary.simpleMessage("Document"),
        "downlaodPath": MessageLookupByLibrary.simpleMessage("Download Path"),
        "downloadTip": MessageLookupByLibrary.simpleMessage(
            "SpeedShare also support Windows、macOS、Linux"),
        "dropFileTip": MessageLookupByLibrary.simpleMessage(
            "Release to share files into the share window"),
        "empty": MessageLookupByLibrary.simpleMessage("Empty"),
        "enableFileClassification":
            MessageLookupByLibrary.simpleMessage("Enable file classification"),
        "enableWebServer":
            MessageLookupByLibrary.simpleMessage("Enable Web Server"),
        "enableWebServerTips": MessageLookupByLibrary.simpleMessage(
            "After enabling, you can access the file in the download path through the browser"),
        "fileDownloadSuccess":
            MessageLookupByLibrary.simpleMessage("File download success"),
        "fileIsDownloading":
            MessageLookupByLibrary.simpleMessage("The file is downloading"),
        "fileManager": MessageLookupByLibrary.simpleMessage("File Manager"),
        "fileManagerLocal":
            MessageLookupByLibrary.simpleMessage("Local File Manager"),
        "fileType": MessageLookupByLibrary.simpleMessage("File Correlation"),
        "headerNotice": m1,
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "image": MessageLookupByLibrary.simpleMessage("Image"),
        "inlineManager":
            MessageLookupByLibrary.simpleMessage("From App FileManager"),
        "inlineManagerTips":
            MessageLookupByLibrary.simpleMessage("It use app\'s file manager"),
        "inputAddressTip": MessageLookupByLibrary.simpleMessage(
            "Please input the file share window address"),
        "inputConnect": MessageLookupByLibrary.simpleMessage("Input Connect"),
        "join": MessageLookupByLibrary.simpleMessage("Join"),
        "joinQQGroup": MessageLookupByLibrary.simpleMessage(
            "Join Feedback Communication Group"),
        "lang": MessageLookupByLibrary.simpleMessage("Language"),
        "linkCopyed": MessageLookupByLibrary.simpleMessage("Link Copied"),
        "log": MessageLookupByLibrary.simpleMessage("Log"),
        "messageNote": MessageLookupByLibrary.simpleMessage(
            "Vibrate When Receive Message"),
        "music": MessageLookupByLibrary.simpleMessage("Music"),
        "new_line": MessageLookupByLibrary.simpleMessage("New Line"),
        "nightmare": MessageLookupByLibrary.simpleMessage("Nightmare"),
        "open": MessageLookupByLibrary.simpleMessage("Open"),
        "openSource": MessageLookupByLibrary.simpleMessage("Open Source"),
        "otherVersion":
            MessageLookupByLibrary.simpleMessage("Download The Other Version"),
        "privacyAgreement":
            MessageLookupByLibrary.simpleMessage("Privacy Agreement"),
        "projectBoard": MessageLookupByLibrary.simpleMessage(
            "Nightmare Series Project Board"),
        "qrTips": MessageLookupByLibrary.simpleMessage(
            "Slide left or right to switch IP addresses"),
        "recentConnect": MessageLookupByLibrary.simpleMessage("Recent Connect"),
        "recentFile": MessageLookupByLibrary.simpleMessage("Recent File"),
        "recentImg": MessageLookupByLibrary.simpleMessage("Recent Image"),
        "remoteAccessDes": MessageLookupByLibrary.simpleMessage(
            "Use broswer open this url can manager file."),
        "remoteAccessFile":
            MessageLookupByLibrary.simpleMessage("Remote Access Local File"),
        "scan": MessageLookupByLibrary.simpleMessage("Scan QR Code"),
        "select": MessageLookupByLibrary.simpleMessage("Select"),
        "sendFile": MessageLookupByLibrary.simpleMessage("Send File"),
        "setting": MessageLookupByLibrary.simpleMessage("Settings"),
        "shareFileFailed":
            MessageLookupByLibrary.simpleMessage("Share File Failed"),
        "systemManager": MessageLookupByLibrary.simpleMessage("From System"),
        "systemManagerTips":
            MessageLookupByLibrary.simpleMessage("It use system file manager"),
        "theTermsOfService":
            MessageLookupByLibrary.simpleMessage("The Terms Of Service"),
        "ui": MessageLookupByLibrary.simpleMessage("UI Designer"),
        "unknownFile": MessageLookupByLibrary.simpleMessage("Unknown File"),
        "uploadFile": MessageLookupByLibrary.simpleMessage("Upload File"),
        "video": MessageLookupByLibrary.simpleMessage("Video"),
        "vipTips": MessageLookupByLibrary.simpleMessage(
            "This function requires a membership to use"),
        "zip": MessageLookupByLibrary.simpleMessage("Zip")
      };
}
