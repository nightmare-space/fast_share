import 'dart:convert';
import 'dart:io';

import 'package:get_server/get_server.dart';
import 'package:global_repository/global_repository.dart';

void createChatServer() {
  Log.d('chat server starting...');
  String home = '';
  if (GetPlatform.isDesktop) {
    home = '/Users/' + Platform.environment['USER'];
  } else {
    home = '/sdcard/';
  }
  runApp(
    GetServerApp(
      port: 7000,
      home: FolderWidget(home),
      getPages: [
        GetPage(name: '/chat', page: () => SocketPage()),
      ],
    ),
  );
  Log.d('chat server down.');
}

class SocketPage extends GetView {
  List<String> msgs = [];
  @override
  Widget build(BuildContext context) {
    return Socket(
      builder: (socket) {
        socket.rawSocket;
        socket.onOpen((ws) {
          Log.d('${ws.id} 已连接');
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
          Log.e(data);
          if (json.decode(data)['type'] == 'getHistory') {
            Log.e('获取历史消息');
            msgs.forEach((element) {
              socket.send(element);
            });
            return;
          }
          print('data: $data');
          msgs.add(data);
          socket.broadcast(data);
        });
        socket.onClose((close) {
          print('socket has closed. Reason: ${close.message}');
        });
      },
    );
  }
}
