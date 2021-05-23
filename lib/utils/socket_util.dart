import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

const int msgByteLen = 2;
const int msgCodeByteLen = 2;
const int minMsgByteLen = msgByteLen + msgCodeByteLen;

class NetworkManager {
  NetworkManager(this.address, this.port);
  final dynamic address;
  final int port;
  Socket socket;
  static Stream<List<int>> mStream;
  Int8List cacheData = Int8List(0);
  static ServerSocket serverSocket;
  Future<void> startServer(void Function(String) listen) async {
    InternetAddress.anyIPv4;
    print('启动 socket');
    serverSocket = await ServerSocket.bind(
      address,
      port,
      shared: true,
    ); //绑定端口4041，根据需要自行修改，建议用动态，防止端口占用
    serverSocket.listen((Socket socket) {
      print('发现连接 ${socket.remoteAddress}');
      listen(socket.remoteAddress.address);
      mStream = socket.asBroadcastStream();
      mStream.listen((event) {
        listen(utf8.decode(event));
        // print('this event ->${utf8.decode(event)}');
      });
    });
    print(
        ' Socket服务启动，正在监听端口 $port... ${serverSocket.address}  ${serverSocket.address}');
  }

  Future<void> stopServer() async {
    print('停止 socket');
    serverSocket?.close();
    // serverSocket.
    print(DateTime.now().toString() + ' Socket服务停止...');
  }

  Future<bool> connect() async {
    try {
      socket = await Socket.connect(
        address,
        port,
        timeout: const Duration(
          seconds: 3,
        ),
      );
      print('连接成功');
      mStream = socket.asBroadcastStream();
      return true;
    } catch (e) {
      print('连接socket出现异常，e=${e.toString()}');
      return false;
    }
    // socket.listen(decodeHandle,
    //     onError: errorHandler, onDone: doneHandler, cancelOnError: false);
  }

  // void decodeHandle(newData) {
  //   // print(newData);
  // }
  void sendByte(List<int> list) {
    final Uint8List outputAsUint8List = Uint8List.fromList(list);
    //给服务器发消息
    try {
      socket.add(outputAsUint8List);
      // print('给服务端发送消息，消息号=$msg');
    } catch (e) {
      // print('send捕获异常：msgCode=$msg，e=${e.toString()}');
    }
  }

  void sendMsg(String msg) {
    final Uint8List outputAsUint8List = Uint8List.fromList(utf8.encode(msg));
    //给服务器发消息
    try {
      socket.add(outputAsUint8List);
      print('给服务端发送消息，消息为 ：$msg');
    } catch (e) {
      print('send捕获异常：msgCode=$msg，e=${e.toString()}');
    }
  }

  // void errorHandler(error, StackTrace trace) {
  //   print('捕获socket异常信息：error=$error，trace=${trace.toString()}');
  //   socket.close();
  // }

  void doneHandler() {
    socket.destroy();
  }
}

mixin SocketManage {
  static String host = 'xxx.xxx.xxx.xxx';
  static int port = 80;
  static Socket mSocket;
  static Stream<List<int>> mStream;

  static Future<void> initSocket() async {
    await Socket.connect(host, port).then((Socket socket) {
      mSocket = socket;
      mStream = mSocket.asBroadcastStream(); //多次订阅的流 如果直接用socket.listen只能订阅一次
    }).catchError((dynamic e) {
      initSocket();
    });
  }

  static void addParams(List<int> params) {
    mSocket.add(params);
  }

  static void dispos() {
    mSocket.close();
  }
}
