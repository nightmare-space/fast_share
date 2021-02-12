import 'dart:io';

class Config {
  Config._();
  static String packageName = 'com.nightmare.adbtools';
  static String curDevicesSerial = '';
  static Map<String, String> devicesMap = {};
  static String historyIp = '';
  static int qrPort = 9000;
  static bool conWhenScan = true;
  // 224.0.0.1 这个组播ip可以实现手机热点电脑，电脑发送组播，手机接收到
  // static InternetAddress multicastAddress = InternetAddress('224.0.0.1');
  static int udpPort = 4545;
}
