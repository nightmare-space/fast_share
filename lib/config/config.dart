class Config {
  Config._();
  static int httpServerPort = 8001;
  static int shelfPort = 8002;
  static int chatPort = 7000;
  // static InternetAddress multicastAddress = InternetAddress('224.0.0.1');
  // flutter package名，因为这个会影响assets的路径
  static String flutterPackage = '';
}
