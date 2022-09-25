import 'package:global_repository/global_repository.dart';
import 'package:speed_share/app/controller/utils/join_util.dart';
import 'package:speed_share/utils/unique_util.dart';

Future<void> receiveUdpMessage(String message, String address) async {
  // Log.w(message);
  final String id = message.split(',').first;
  final String port = message.split(',').last;
  // if(message)
  // Log.e('UniqueUtil.getDevicesId() -> ${UniqueUtil.getDevicesId()}');

  if ((await PlatformUtil.localAddress()).contains(address)) {
    return;
  }
  if (id.trim() != await UniqueUtil.getDevicesId()) {
    sendJoinEvent('http://$address:$port');
  }
}
