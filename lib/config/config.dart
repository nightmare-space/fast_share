import 'dart:io';

class Config {
  Config._();
  static int shelfAllPort = 8000;
  static int httpServerPort = 8002;
  static int shelfPort = 8001;
  static int chatPort = 7000;
  static String packageName = 'com.nightmare.speedshare';
  // static InternetAddress multicastAddress = InternetAddress('224.0.0.1');
  // flutter package名，因为这个会影响assets的路径
  static String flutterPackage = '';
  static InternetAddress mDnsAddressIPv4 = InternetAddress('224.0.0.251');
}
