import 'dart:convert';
import 'dart:io';

/// 通过组播+广播的方式，让设备能够相互在局域网被发现

InternetAddress _mDnsAddressIPv4 = InternetAddress('224.0.0.251');

class Multicast {
  void start() {}
  void stop() {}
  void listen() {}

  /// 接收广播消息
  Future<void> _receiveBoardCast() async {
    RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      4545,
      reuseAddress: true,
      reusePort: false,
      ttl: 255,
    ).then((RawDatagramSocket socket) {
      socket.joinMulticast(_mDnsAddressIPv4);
      // 开启广播支持
      socket.broadcastEnabled = true;
      socket.readEventsEnabled = true;
      socket.listen((RawSocketEvent rawSocketEvent) async {
        final Datagram datagram = socket.receive();
        if (datagram == null) {
          return;
        }
        String message = utf8.decode(datagram.data);
      });
    });
  }

  Future<void> startSendBoardCast(String data) async {
    // isStartSend = true;
    // socket = await RawDatagramSocket.bind(
    //   InternetAddress.anyIPv4,
    //   0,
    //   ttl: 255,
    // );
    // socket.broadcastEnabled = true;
    // socket.readEventsEnabled = true;
    // Stopwatch stopwatch = Stopwatch();
    // stopwatch.start();
    // print('start ${stopwatch.elapsed}');
    // while (true) {
    //   UdpUtil.boardcast(socket, uniqueKey.toString() + ' ' + data);
    //   if (!isStartSend) {
    //     break;
    //   }
    //   await Future.delayed(Duration(seconds: 1));
    // }
  }

  Future<void> stopSendBoradcast() async {
    // if (!isStartSend) {
    //   return;
    // }
    // isStartSend = false;
    // socket.close();
  }
}
