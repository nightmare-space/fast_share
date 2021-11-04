import 'dart:io';

import 'package:global_repository/global_repository.dart';

class UniqueUtil {
  UniqueUtil._();
  static Future<String> getDevicesId() async {
    if (PlatformUtil.isDesktop()) {
      return Platform.operatingSystem;
    } else {
      props ??= await YanProcess().exec('getprop');
      // print(props);
      // print(getValueFromProps('ro.product.model'));
      return getValueFromProps('ro.product.model');
    }
  }

  static String props;
  static String getValueFromProps(String key) {
    final List<String> tmp = props.split('\n');
    for (final String line in tmp) {
      if (line.contains(key)) {
        return line.replaceAll(RegExp('.*\\]: |\\[|\\]'), '');
      }
    }
    return '';
    // print(key);
  }
}
