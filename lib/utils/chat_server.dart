import 'package:get_server/get_server.dart';
import 'package:global_repository/global_repository.dart';

void createChatServer() {
  Log.d('chat server starting...');
  runApp(
    GetServerApp(
      port: 7000,
      // home: FolderWidget('/sdcard/'),
      getPages: [
        GetPage(name: '/chat', page: () => SocketPage()),
      ],
    ),
  );
  Log.d('chat server down.');
}

class SocketPage extends GetView {
  @override
  Widget build(BuildContext context) {
    return Socket(
      builder: (socket) {
        socket.onOpen((ws) {
          Log.d('${ws.id}已连接');
          // ws.send('socket ${ws.id} connected');
        });
        socket.on('join', (val) {
          print('val -> $val');
          final join = socket.join(val);
          if (join) {
            socket.sendToRoom(val, 'socket: ${socket.hashCode} join to room');
          }
        });
        socket.onMessage((data) {
          // 分msgtype，img，tip，text
          print('data: $data');
          socket.broadcast(data);
        });
        socket.onClose((close) {
          print('socket has closed. Reason: ${close.message}');
        });
      },
    );
  }
}
