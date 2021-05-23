import 'package:get_server/get_server.dart';

void getmain() {
  print('object');
  runApp(
    GetServerApp(
      port: 1234,
      home: FolderWidget('/sdcard/'),
      getPages: [
        GetPage(name: '/chat', page: () => SocketPage()),
      ],
    ),
  );
}

class SocketPage extends GetView {
  @override
  Widget build(BuildContext context) {
    return Socket(builder: (socket) {
      print('socket.onOpen');
      socket.onOpen((ws) {
        ws.send('socket ${ws.id} connected');
      });
      print('加入123');
      socket.on('join', (val) {
        print('val -> $val');
        final join = socket.join(val);
        if (join) {
          socket.sendToRoom(val, 'socket: ${socket.hashCode} join to room');
        }
      });
      socket.join('123');
      socket.onMessage((data) {
        print('data: $data');
        socket.broadcast(data);
      });

      socket.onClose((close) {
        print('socket has closed. Reason: ${close.message}');
      });
    });
  }
}
