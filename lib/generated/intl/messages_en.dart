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
        "apk": MessageLookupByLibrary.simpleMessage("Apk"),
        "appName": MessageLookupByLibrary.simpleMessage("Speed Share"),
        "autoDownload": MessageLookupByLibrary.simpleMessage("Auto Download"),
        "cacheSize": m0,
        "changeLog": MessageLookupByLibrary.simpleMessage("Change Log"),
        "chatWindow": MessageLookupByLibrary.simpleMessage("Chat Window"),
        "chatWindowNotice": MessageLookupByLibrary.simpleMessage(
            "Currently no messages, click to view the message list"),
        "clearCache": MessageLookupByLibrary.simpleMessage("Clear Cache"),
        "clearSuccess": MessageLookupByLibrary.simpleMessage("Clear Success"),
        "clipboardshare":
            MessageLookupByLibrary.simpleMessage("Clipboard Share"),
        "common": MessageLookupByLibrary.simpleMessage("Common"),
        "currenVersion":
            MessageLookupByLibrary.simpleMessage("Current Version"),
        "currentRoom": MessageLookupByLibrary.simpleMessage("Chat Room"),
        "developer": MessageLookupByLibrary.simpleMessage("Developer"),
        "directory": MessageLookupByLibrary.simpleMessage("Directory"),
        "doc": MessageLookupByLibrary.simpleMessage("Document"),
        "downlaodPath": MessageLookupByLibrary.simpleMessage("Download Path"),
        "downloadTip": MessageLookupByLibrary.simpleMessage(
            "SpeedShare also support Windows、macOS、Linux"),
        "empty": MessageLookupByLibrary.simpleMessage("Empty"),
        "enableFileClassification":
            MessageLookupByLibrary.simpleMessage("Enable file classification"),
        "enbaleWebServer":
            MessageLookupByLibrary.simpleMessage("Enable Web Server"),
        "headerNotice": m1,
        "image": MessageLookupByLibrary.simpleMessage("Image"),
        "inputConnect": MessageLookupByLibrary.simpleMessage("Input Connect"),
        "joinQQGroup": MessageLookupByLibrary.simpleMessage(
            "Join Feedback Communication Group"),
        "lang": MessageLookupByLibrary.simpleMessage("Language"),
        "log": MessageLookupByLibrary.simpleMessage("Log"),
        "messageNote": MessageLookupByLibrary.simpleMessage(
            "Vibrate When Receive Message"),
        "music": MessageLookupByLibrary.simpleMessage("Music"),
        "nightmare": MessageLookupByLibrary.simpleMessage("Nightmare"),
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
        "setting": MessageLookupByLibrary.simpleMessage("Settings"),
        "theTermsOfService":
            MessageLookupByLibrary.simpleMessage("The Terms Of Service"),
        "ui": MessageLookupByLibrary.simpleMessage("UI Designer"),
        "unknownFile": MessageLookupByLibrary.simpleMessage("Unknown File"),
        "video": MessageLookupByLibrary.simpleMessage("Video"),
        "zip": MessageLookupByLibrary.simpleMessage("Zip")
      };
}
