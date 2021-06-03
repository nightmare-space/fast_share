import 'dart:convert';
import 'dart:io';

import 'package:get_server/get_server.dart';
import 'package:global_repository/global_repository.dart';

void createChatServer() {
  Log.d('chat server starting...');
  String home = '';
  if (GetPlatform.isDesktop) {
    home = RuntimeEnvir.filesPath;
  } else {
    home = RuntimeEnvir.filesPath;
  }
  runApp(
    GetServerApp(
      useLog: false,
      port: 7000,
      home: FolderWidget(home),
      getPages: [
        GetPage(name: '/chat', page: () => SocketPage()),
      ],
    ),
  );
  Log.d('chat server down.');
}

// ignore: must_be_immutable
class SocketPage extends GetView {
  List<String> msgs = [];
  @override
  Widget build(BuildContext context) {
    return Socket(
      builder: (socket) {
        socket.rawSocket;
        socket.onOpen((ws) {
          Log.v('${ws.id} 已连接');
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
          if (data.toString().isEmpty) {
            // 很诡异，chrome的ws连接过来，会一直发空字符串
            return;
          }
          try {
            if (json.decode(data)['type'] == 'getHistory') {
              Log.v('客户端请求获取历史消息');
              if (msgs.isEmpty) {
                return;
              }
              msgs.forEach((element) {
                socket.send(element);
              });
              socket.send(json.encode({
                'msgType': 'tip',
                'content': '以上是历史消息',
              }));
              return;
            }
          } catch (e) {
            Log.e('e -> $e');
          }

          Log.v('服务端收到消息: $data');
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
