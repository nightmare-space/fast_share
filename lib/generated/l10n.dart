// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Common`
  String get common {
    return Intl.message(
      'Common',
      name: 'common',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting {
    return Intl.message(
      'Settings',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Download Path`
  String get downlaodPath {
    return Intl.message(
      'Download Path',
      name: 'downlaodPath',
      desc: '',
      args: [],
    );
  }

  /// `Auto Download`
  String get autoDownload {
    return Intl.message(
      'Auto Download',
      name: 'autoDownload',
      desc: '',
      args: [],
    );
  }

  /// `Clipboard Share`
  String get clipboardshare {
    return Intl.message(
      'Clipboard Share',
      name: 'clipboardshare',
      desc: '',
      args: [],
    );
  }

  /// `Vibrate When Receive Message`
  String get messageNote {
    return Intl.message(
      'Vibrate When Receive Message',
      name: 'messageNote',
      desc: '',
      args: [],
    );
  }

  /// `About Speed Share`
  String get aboutSpeedShare {
    return Intl.message(
      'About Speed Share',
      name: 'aboutSpeedShare',
      desc: '',
      args: [],
    );
  }

  /// `Current Version`
  String get currenVersion {
    return Intl.message(
      'Current Version',
      name: 'currenVersion',
      desc: '',
      args: [],
    );
  }

  /// `Download The Other Version`
  String get otherVersion {
    return Intl.message(
      'Download The Other Version',
      name: 'otherVersion',
      desc: '',
      args: [],
    );
  }

  /// `SpeedShare also support Windows、macOS、Linux`
  String get downloadTip {
    return Intl.message(
      'SpeedShare also support Windows、macOS、Linux',
      name: 'downloadTip',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get lang {
    return Intl.message(
      'Language',
      name: 'lang',
      desc: '',
      args: [],
    );
  }

  /// `Chat Window`
  String get chatWindow {
    return Intl.message(
      'Chat Window',
      name: 'chatWindow',
      desc: '',
      args: [],
    );
  }

  /// `Developer`
  String get developer {
    return Intl.message(
      'Developer',
      name: 'developer',
      desc: '',
      args: [],
    );
  }

  /// `Open Source`
  String get openSource {
    return Intl.message(
      'Open Source',
      name: 'openSource',
      desc: '',
      args: [],
    );
  }

  /// `Input Connect`
  String get inputConnect {
    return Intl.message(
      'Input Connect',
      name: 'inputConnect',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR Code`
  String get scan {
    return Intl.message(
      'Scan QR Code',
      name: 'scan',
      desc: '',
      args: [],
    );
  }

  /// `Log`
  String get log {
    return Intl.message(
      'Log',
      name: 'log',
      desc: '',
      args: [],
    );
  }

  /// `The Terms Of Service`
  String get theTermsOfService {
    return Intl.message(
      'The Terms Of Service',
      name: 'theTermsOfService',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Agreement`
  String get privacyAgreement {
    return Intl.message(
      'Privacy Agreement',
      name: 'privacyAgreement',
      desc: '',
      args: [],
    );
  }

  /// `Slide left or right to switch IP addresses`
  String get qrTips {
    return Intl.message(
      'Slide left or right to switch IP addresses',
      name: 'qrTips',
      desc: '',
      args: [],
    );
  }

  /// `UI Designer`
  String get ui {
    return Intl.message(
      'UI Designer',
      name: 'ui',
      desc: '',
      args: [],
    );
  }

  /// `Recent File`
  String get recentFile {
    return Intl.message(
      'Recent File',
      name: 'recentFile',
      desc: '',
      args: [],
    );
  }

  /// `Recent Image`
  String get recentImg {
    return Intl.message(
      'Recent Image',
      name: 'recentImg',
      desc: '',
      args: [],
    );
  }

  /// `Chat Room`
  String get currentRoom {
    return Intl.message(
      'Chat Room',
      name: 'currentRoom',
      desc: '',
      args: [],
    );
  }

  /// `Remote Access Local File`
  String get remoteAccessFile {
    return Intl.message(
      'Remote Access Local File',
      name: 'remoteAccessFile',
      desc: '',
      args: [],
    );
  }

  /// `Use broswer open this url can manager file.`
  String get remoteAccessDes {
    return Intl.message(
      'Use broswer open this url can manager file.',
      name: 'remoteAccessDes',
      desc: '',
      args: [],
    );
  }

  /// `Directory`
  String get directory {
    return Intl.message(
      'Directory',
      name: 'directory',
      desc: '',
      args: [],
    );
  }

  /// `Unknown File`
  String get unknownFile {
    return Intl.message(
      'Unknown File',
      name: 'unknownFile',
      desc: '',
      args: [],
    );
  }

  /// `Zip`
  String get zip {
    return Intl.message(
      'Zip',
      name: 'zip',
      desc: '',
      args: [],
    );
  }

  /// `Document`
  String get doc {
    return Intl.message(
      'Document',
      name: 'doc',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get music {
    return Intl.message(
      'Music',
      name: 'music',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message(
      'Image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Apk`
  String get apk {
    return Intl.message(
      'Apk',
      name: 'apk',
      desc: '',
      args: [],
    );
  }

  /// `Speed Share`
  String get appName {
    return Intl.message(
      'Speed Share',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `{number,plural, =0{No devices connect}other{have {number} connected}}`
  String headerNotice(num number) {
    return Intl.plural(
      number,
      zero: 'No devices connect',
      other: 'have $number connected',
      name: 'headerNotice',
      desc: '',
      args: [number],
    );
  }

  /// `Recent Connect`
  String get recentConnect {
    return Intl.message(
      'Recent Connect',
      name: 'recentConnect',
      desc: '',
      args: [],
    );
  }

  /// `Empty`
  String get empty {
    return Intl.message(
      'Empty',
      name: 'empty',
      desc: '',
      args: [],
    );
  }

  /// `Nightmare Series Project Board`
  String get projectBoard {
    return Intl.message(
      'Nightmare Series Project Board',
      name: 'projectBoard',
      desc: '',
      args: [],
    );
  }

  /// `Join Feedback Communication Group`
  String get joinQQGroup {
    return Intl.message(
      'Join Feedback Communication Group',
      name: 'joinQQGroup',
      desc: '',
      args: [],
    );
  }

  /// `Change Log`
  String get changeLog {
    return Intl.message(
      'Change Log',
      name: 'changeLog',
      desc: '',
      args: [],
    );
  }

  /// `About Speed Share`
  String get about {
    return Intl.message(
      'About Speed Share',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Currently no messages, click to view the message list`
  String get chatWindowNotice {
    return Intl.message(
      'Currently no messages, click to view the message list',
      name: 'chatWindowNotice',
      desc: '',
      args: [],
    );
  }

  /// `Enable file classification`
  String get enableFileClassification {
    return Intl.message(
      'Enable file classification',
      name: 'enableFileClassification',
      desc: '',
      args: [],
    );
  }

  /// `Clear Cache`
  String get clearCache {
    return Intl.message(
      'Clear Cache',
      name: 'clearCache',
      desc: '',
      args: [],
    );
  }

  /// `Clear Success`
  String get clearSuccess {
    return Intl.message(
      'Clear Success',
      name: 'clearSuccess',
      desc: '',
      args: [],
    );
  }

  /// `{number,plural, other{Current cache size {number}MB}}`
  String cacheSize(num number) {
    return Intl.plural(
      number,
      other: 'Current cache size ${number}MB',
      name: 'cacheSize',
      desc: '',
      args: [number],
    );
  }

  /// `Nightmare`
  String get nightmare {
    return Intl.message(
      'Nightmare',
      name: 'nightmare',
      desc: '',
      args: [],
    );
  }

  /// `Enable Web Server`
  String get enbaleWebServer {
    return Intl.message(
      'Enable Web Server',
      name: 'enbaleWebServer',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
