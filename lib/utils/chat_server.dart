import 'dart:convert';

import 'package:get_server/get_server.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/config/config.dart';

// 聊天服务器，返回成功绑定的端口号
Future<int> createChatServer() async {
  Log.d('chat server starting...');
  String home = '';
  if (GetPlatform.isDesktop) {
    home = RuntimeEnvir.filesPath;
  } else {
    home = RuntimeEnvir.filesPath;
  }
  int port = await getSafePort(
    Config.chatPortRangeStart,
    Config.chatPortRangeEnd,
  );
  GetServerApp serverApp = GetServerApp(
    useLog: false,
    port: port,
    home: FolderWidget(home),
    getPages: [
      GetPage(name: '/chat', page: () => SocketPage()),
    ],
    shared: true,
    onNotFound: NotFound(),
  );
  runApp(serverApp);
  Log.d('chat server down.');
  return port;
}

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('把端口换成7000试试');
  }
}

// ignore: must_be_immutable
class SocketPage extends GetView {
  List<String> msgs = [];
  List<GetSocket> sockets = [];
  // 储存ws id和设备名的map
  Map<int, String> deviceNameStore = {};
  void dispatch(GetSocket socket, Map jsonMap) {
    String type = jsonMap['type'];
    switch (type) {
      case 'join':
        return;
      case 'getHistory':
        // 说明是请求历史消息，把历史消息单独发给这个客户端
        Log.v('客户端请求获取历史消息');
        if (msgs.isEmpty) {
          return;
        }
        for (String msg in msgs) {
          // 这个发了，加入的才能收到
          socket.send(msg);
        }
        // todo
        // if (msgs.isNotEmpty) {
        //   socket.send(json.encode({
        //     'msgType': 'tip',
        //     'content': '以上是历史消息',
        //   }));
        // }
        return;
      default:
        String msgType = jsonMap['msgType'];
        if (msgType == 'join') {
          // 有A B C设备
          // B加入房间，就是用的B的ws进行的广播，A C会收到消息，B自己不会收到消息，
          String sendId = jsonMap['deviceId'];
          // todo 这一步可以干掉
          deviceNameStore[socket.id] = sendId;
        }
        // 保存到历史
        msgs.add(jsonEncode(jsonMap));
        // 广播到其他设备
        socket.broadcast(jsonEncode(jsonMap));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Socket(
      builder: (socket) {
        sockets.add(socket);
        // Log.e('连接');
        socket.onOpen((ws) {
          Log.v('${ws.id} 已连接');
          // ws.send('socket ${ws.id} connected');
        });

        socket.onMessage((data) {
          if (data.toString().isEmpty) {
            // 很诡异，chrome的ws连接过来，会一直发空字符串
            return;
          }
          Map<String, dynamic> jsonMap;
          try {
            jsonMap = json.decode(data);
            dispatch(socket, jsonMap);
          } catch (e) {
            Log.e('json.decode error -> $e');
          }
          Log.i('服务端收到消息: $data');
        });
        socket.onClose((close) {
          sockets.remove(socket);
          if (sockets.isNotEmpty) {
            // 这儿不放到dispose，是因为app被杀掉，dispose收不到
            String name = deviceNameStore.remove(socket.id);
            for (GetSocket socket in sockets) {
              socket.send(json.encode({
                'msgType': 'exit',
                'deviceId': name,
                'content': '$name 退出房间',
              }));
            }
          }
          Log.v('$socket socket has closed. Reason: ${close.message}');
        });
      },
    );
  }
}
