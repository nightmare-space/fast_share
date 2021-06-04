import 'dart:io';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/config/config.dart';

class UdpUtil {
  static Future<void> boardcast(RawDatagramSocket socket, String msg) async {
    socket.send(msg.codeUnits, Config.mDnsAddressIPv4, 4545);
    await Future.delayed(const Duration(milliseconds: 10));
    // return;
    final List<String> address = await PlatformUtil.localAddress();
    for (final String addr in address) {
      final tmp = addr.split('.');
      tmp.removeLast();
      final String addrPrfix = tmp.join('.');
      final InternetAddress address = InternetAddress(
        '$addrPrfix\.255',
      );
      socket.send(
        msg.codeUnits,
        address,
        4545,
      );
    }
  }
}
