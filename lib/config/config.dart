class Config {
  Config._();
  static int shelfAllPort = 8000;
  static int httpServerPort = 8002;
  static int shelfPortRangeStart = 13000;
  static int shelfPortRangeEnd = 13010;
  static int filePortRangeStart = 13010;
  static int filePortRangeEnd = 13020;
  static int chatPortRangeStart = 12000;
  static int chatPortRangeEnd = 12010;
  static String packageName = 'com.nightmare.speedshare';
  // flutter package名，因为这个会影响assets的路径
  static String flutterPackage = '';
}
