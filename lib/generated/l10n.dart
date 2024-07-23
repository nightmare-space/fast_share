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

  /// `Note, after the file classification is turned on, all files in the download path will be automatically organized`
  String get classifyTips {
    return Intl.message(
      'Note, after the file classification is turned on, all files in the download path will be automatically organized',
      name: 'classifyTips',
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

  /// `Current Cache Size`
  String get curCacheSize {
    return Intl.message(
      'Current Cache Size',
      name: 'curCacheSize',
      desc: '',
      args: [],
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
  String get enableWebServer {
    return Intl.message(
      'Enable Web Server',
      name: 'enableWebServer',
      desc: '',
      args: [],
    );
  }

  /// `After enabling, you can access the file in the download path through the browser`
  String get enableWebServerTips {
    return Intl.message(
      'After enabling, you can access the file in the download path through the browser',
      name: 'enableWebServerTips',
      desc: '',
      args: [],
    );
  }

  /// `File Correlation`
  String get fileType {
    return Intl.message(
      'File Correlation',
      name: 'fileType',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `This function requires a membership to use`
  String get vipTips {
    return Intl.message(
      'This function requires a membership to use',
      name: 'vipTips',
      desc: '',
      args: [],
    );
  }

  /// `The file is downloading`
  String get fileIsDownloading {
    return Intl.message(
      'The file is downloading',
      name: 'fileIsDownloading',
      desc: '',
      args: [],
    );
  }

  /// `File download success`
  String get fileDownloadSuccess {
    return Intl.message(
      'File download success',
      name: 'fileDownloadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Send File`
  String get sendFile {
    return Intl.message(
      'Send File',
      name: 'sendFile',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Devices`
  String get device {
    return Intl.message(
      'Devices',
      name: 'device',
      desc: '',
      args: [],
    );
  }

  /// `Upload File`
  String get uploadFile {
    return Intl.message(
      'Upload File',
      name: 'uploadFile',
      desc: '',
      args: [],
    );
  }

  /// `All Devices`
  String get allDevices {
    return Intl.message(
      'All Devices',
      name: 'allDevices',
      desc: '',
      args: [],
    );
  }

  /// `From System`
  String get systemManager {
    return Intl.message(
      'From System',
      name: 'systemManager',
      desc: '',
      args: [],
    );
  }

  /// `It use system file manager`
  String get systemManagerTips {
    return Intl.message(
      'It use system file manager',
      name: 'systemManagerTips',
      desc: '',
      args: [],
    );
  }

  /// `From App FileManager`
  String get inlineManager {
    return Intl.message(
      'From App FileManager',
      name: 'inlineManager',
      desc: '',
      args: [],
    );
  }

  /// `It use app's file manager`
  String get inlineManagerTips {
    return Intl.message(
      'It use app\'s file manager',
      name: 'inlineManagerTips',
      desc: '',
      args: [],
    );
  }

  /// `New Line`
  String get new_line {
    return Intl.message(
      'New Line',
      name: 'new_line',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get join {
    return Intl.message(
      'Join',
      name: 'join',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get connected {
    return Intl.message(
      'Connected',
      name: 'connected',
      desc: '',
      args: [],
    );
  }

  /// `Disconnected`
  String get disconnected {
    return Intl.message(
      'Disconnected',
      name: 'disconnected',
      desc: '',
      args: [],
    );
  }

  /// `Android SAF architecture will cause the file selected from the system folder to always be copied. If you use the SpeedShare's file manager to select, it will not increase the cache size`
  String get androidSAFTips {
    return Intl.message(
      'Android SAF architecture will cause the file selected from the system folder to always be copied. If you use the SpeedShare\'s file manager to select, it will not increase the cache size',
      name: 'androidSAFTips',
      desc: '',
      args: [],
    );
  }

  /// `Local File Manager`
  String get fileManagerLocal {
    return Intl.message(
      'Local File Manager',
      name: 'fileManagerLocal',
      desc: '',
      args: [],
    );
  }

  /// `File Manager`
  String get fileManager {
    return Intl.message(
      'File Manager',
      name: 'fileManager',
      desc: '',
      args: [],
    );
  }

  /// `Share File Failed`
  String get shareFileFailed {
    return Intl.message(
      'Share File Failed',
      name: 'shareFileFailed',
      desc: '',
      args: [],
    );
  }

  /// `Release to share files into the share window`
  String get dropFileTip {
    return Intl.message(
      'Release to share files into the share window',
      name: 'dropFileTip',
      desc: '',
      args: [],
    );
  }

  /// `Please input the file share window address`
  String get inputAddressTip {
    return Intl.message(
      'Please input the file share window address',
      name: 'inputAddressTip',
      desc: '',
      args: [],
    );
  }

  /// `Link Copied`
  String get copyed {
    return Intl.message(
      'Link Copied',
      name: 'copyed',
      desc: '',
      args: [],
    );
  }

  /// `Cache Cleaned`
  String get cacheCleaned {
    return Intl.message(
      'Cache Cleaned',
      name: 'cacheCleaned',
      desc: '',
      args: [],
    );
  }

  /// `Exception Occur`
  String get exceptionOrcur {
    return Intl.message(
      'Exception Occur',
      name: 'exceptionOrcur',
      desc: '',
      args: [],
    );
  }

  /// `Clipboard Copied`
  String get clipboardCopy {
    return Intl.message(
      'Clipboard Copied',
      name: 'clipboardCopy',
      desc: '',
      args: [],
    );
  }

  /// `No IP Found`
  String get noIPFound {
    return Intl.message(
      'No IP Found',
      name: 'noIPFound',
      desc: '',
      args: [],
    );
  }

  /// `Back again to exit the app`
  String get backAgainTip {
    return Intl.message(
      'Back again to exit the app',
      name: 'backAgainTip',
      desc: '',
      args: [],
    );
  }

  /// `Tap to view all files of {deviceName}`
  String tapToViewFile(Object deviceName) {
    return Intl.message(
      'Tap to view all files of $deviceName',
      name: 'tapToViewFile',
      desc: '',
      args: [deviceName],
    );
  }

  /// `The browser has been notified to upload the file`
  String get notifyBroswerTip {
    return Intl.message(
      'The browser has been notified to upload the file',
      name: 'notifyBroswerTip',
      desc: '',
      args: [],
    );
  }

  /// `Clipboard`
  String get clipboard {
    return Intl.message(
      'Clipboard',
      name: 'clipboard',
      desc: '',
      args: [],
    );
  }

  /// `File QR Code`
  String get fileQRCode {
    return Intl.message(
      'File QR Code',
      name: 'fileQRCode',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get export {
    return Intl.message(
      'Export',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Open QQ Fail, Please check if it is installed`
  String get openQQFail {
    return Intl.message(
      'Open QQ Fail, Please check if it is installed',
      name: 'openQQFail',
      desc: '',
      args: [],
    );
  }

  /// `Please enable WebServer in SpeedShare first`
  String get needWSTip {
    return Intl.message(
      'Please enable WebServer in SpeedShare first',
      name: 'needWSTip',
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
