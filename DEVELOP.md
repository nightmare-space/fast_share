# 开发者文档

速享使用 websocket 构建了基于聊天服务器(由 get_server 搭建)的文件共享窗口，文件部署使用的是 shelf 相关的库。
聊天窗口发送的为 json 类型的消息，根据不同的消息类型用不同的字段进行区分。
速享集成一些由 dart 编写的服务端代码从而实现了文件的下载。

## 文件结构
```sh
├── app # GetX 相关的文件配置
│   ├── bindings
│   ├── controller
│   └── routes
├── config
│   ├── assets.dart # svg 资源文件配置
│   └── config.dart # 端口等配置
├── generated_plugin_registrant.dart
├── global
│   └── global.dart # 全局单例，用来发现设备，解压 web 资源
├── main.dart # app 启动入口文件
├── pages
│   ├── dialog # 弹窗相关页面
│   ├── home_page.dart # 主页显示文件夹
│   ├── item # 聊天页面的 item 组件所在的文件夹
│   ├── model # 聊天相关的 model
│   ├── online_list.dart # 设备发现列表组件
│   ├── qrscan_page.dart # 二维码扫描页面
│   ├── setting_page.dart # 设置页面
│   ├── share_chat_window.dart # 聊天窗口
│   └── video.dart # 视频预览
├── routes
│   └── page_route_builder.dart
├── themes # 主题相关文件夹
│   ├── app_colors.dart
│   ├── color_schema_extension.dart
│   ├── default_theme_data.dart
│   └── theme.dart
├── utils # 一些工具类
│   ├── chat_server.dart # 聊天服务器的代码在这里面
│   ├── document # 安全的使用 web 端的url方案
│   ├── http # dio 的封装
│   ├── process_server.dart
│   ├── proxy.dart
│   ├── scan_util.dart # 二维码扫描
│   ├── shelf # 部署文件供其他端下载的 server
│   ├── shelf_static.dart # 类似于 tomcat/nginx 的文件批量部署
│   ├── string_extension.dart
│   └── utils.dart
└── widgets
    └── circle_animation.dart # 主页那个动画
```
## web 端实现方案
首先 web 端也是由 flutter 编写，并且是同一套代码兼容过去的。web 端不支持创建房间，所以在打开的时候，直接进到的就行文件共享的窗口。

使用`flutter build web `命令直接将速享编译到 web，然后作为资源文件添加到客户端中。

在启动的时候，会解压这个资源文件到私有目录。

并在速享创建房间的时候，将这个 web 端部署到了聊天服务器同一个端口上。
代码如下：
```dart
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
```
`/`指向的就是部署的速享 web 端，`/chat`指向的是聊天服务器。


所以在 web 端的默认页面不是 `/`，这个很好实现。
```dart
    String initRoute = SpeedPages.INITIAL;
    if (GetPlatform.isWeb) {
      initRoute = Routes.chat;
    }
```
然后聊天的 url 即浏览器上面打开的 url，通过 `dart:html` 的 `window.document.baseUri` 就能获取到。

所以这也是聊天服务器选择 WebSocket 的原因，因为要支持 web 端。
## 局域网发现实现方案

基础库为[multicast](https://github.com/nightmare-space/multicast)

其实具体代码不多，利用的是 UDP 广播+组播 实现的，但只能适用于简单的局域网，因为在复杂的局域网中，我们不能知道其中所有的广播地址，除非获取到它划分子网的规则。

每个客户端监听本地一个端口的 udp 消息，某一端创建房间后，会定时发送`$id,$port`的消息。

id 是一个 short hash，port 是这个房间成功启动到的端口号。

其他端收到这个消息，外加 UDP 通信本就能获得对方的 ip，所以就能够解析出一个能够加入到房间的 url，

## 历史消息实现方案
聊天服务器会保存所有发送过的消息，在任意客户端加入房间的时候，会先发送如下信息:
```json
{
  "type":"getHistory"
}
服务端根据 type，将缓存的 message 发送到这个新连接的客户端上面。
```
## 端口占用解决方案

速享有两个地方会占用端口，一是创建聊天服务器会占用一个端口，二是部署文件供其他端下载也会占用一个端口。
因为需要考虑这个端口是否已经被其他进程占用了，所以实现了一个更兼容的获取端口的方案。
代码如下：
```dart
Future<int> getSafePort(int rangeStart, int rangeEnd) async {
  if (rangeStart == rangeEnd) {
    // 说明都失败了
    return null;
  }
  try {
    await ServerSocket.bind(
      '0.0.0.0',
      rangeStart,
      shared: true,
    );
    Log.w('端口$rangeStart绑定成功');
    return rangeStart;
  } catch (e) {
    Log.e('端口$rangeStart绑定失败');
    return await getSafePort(rangeStart + 1, rangeEnd);
  }
}
这是一个获得可用端口的函数，留意`shared: true`，这个属性，不会导致端口依然被这个函数占用。
```
## 文件互传实现

速享的文件共享分三部步：

**1. 静态部署选择的文件**

这部分更多是后端的知识，但理解起来不难，以文件的完整路径为 url 响应对应的文件内容即可。
速享并不关心自己何时需要发送文件，例如下载服务器上部署的文件，服务器只需要监听、响应，不关心具体何时进行发送。
```dart
  void serverFile(String path) {
    Log.e('部署 path -> $path');
    String filePath = path.replaceAll('\\', '/');
    filePath = filePath.replaceAll(RegExp('^[A-Z]:'), '');
    filePath = filePath.replaceAll(RegExp('^/'), '');
    // 部署文件
    String url = p.toUri(filePath).toString();
    Log.e('部署 url -> $url');
    var handler = createFileHandler(path, url: url);
    io.serve(
      handler,
      InternetAddress.anyIPv4,
      shelfBindPort,
      shared: true,
    );
  }
```
`createFileHandler` 以及 `io.serve` 都是 dart 官方的 package。

**2. 发送聊天消息，并带上文件的路径，和本机所在的ip 列表**

与其他文件共享不一样，速享只是告诉其他它端应该从哪儿下到这个文件，而不是直接发送。
其他的根据消息中所包含的 IP 列表，计算出文件的下载地址，

```json
{
    "msgType":"file",
    "fileName":"文件名",
    "filePath":"文件路径",
    "fileSize":"文件大小(human readable)",
    "url":"http://a.a.a.a:12000 http://x.x.x.x:12000 http://c.c.c.:12000"
}
```

url 列表是发送端的所在的 ip 列表组成的，其他端如何选择一个正确的 url 看下面的[IP 选择实现](#IP 选择实现) 

**3. 其它端发起 Get 请求下载文件**
略~
## Web 端上传文件实现
web 不支持部署某个文件，所以只支持上传一个 blob 代表的文件，客户端部署对应的文件接收服务。

并且要实现一对多的传输，简单说就是，浏览器发送一个文件，其他多个客户端都能正常下载。

**1. 客户端响应文件接收**

这部分资料较少，但油管有一个视频教程非常不错，[Dart File Upload Server Tutorial](https://www.youtube.com/watch?v=hSkD3y9HMro)
代码在[file_server.dart](lib/utils/file_server.dart)
## IP 选择实现
有这种场景，设备 A 的 ip 列表为 [ip1,ip2,ip3],此时设备 A 发起共享，设备 B 通过 ip1 加入共享，设备 C 通过 ip2 加入共享，设备 D 通过 ip3 加入共享。
<!-- 由上面互传的实现，无论哪个设备发送文件，都会带上自己的局域网 ip 列表。 -->
在任意设备处于房间中的时候，都部署了一个简单的校验文件，代码如下。
```dart
  void serverTokenFile() {
    String tokenPath = RuntimeEnvir.filesPath + '/check_token';
    File(tokenPath).writeAsStringSync('success');
    var handler = createFileHandler(
      tokenPath,
      url: 'check_token',
    );
    io.serve(
      handler,
      InternetAddress.anyIPv4,
      shelfBindPort,
      shared: true,
    );
  }
```
在任意设备收到消息的时候，会根据消息所带的 ip 列表，去访问那个 token 文件，如果能访问到，说明本机与这个 ip 互通。
代码如下：
```dart

  Future<String> getToken(String url) async {
    Log.d('$url/check_token');
    Completer lock = Completer();
    CancelToken cancelToken = CancelToken();
    Response response;
    Future.delayed(Duration(milliseconds: 300), () {
      if (!lock.isCompleted) {
        cancelToken.cancel();
      }
    });
    try {
      response = await httpInstance.get(
        '$url/check_token',
        cancelToken: cancelToken,
      );
      if (!lock.isCompleted) {
        lock.complete(response.data);
      }
      Log.w(response.data);
    } catch (e) {
      if (!lock.isCompleted) {
        lock.complete(null);
      }
      Log.w('$url无法访问 $e');
    }
    return await lock.future;
  }
   for (String url in messageInfo.url.split(' ')) {
        String token = await getToken(url);
        if (token != null) {
          messageInfo.url = url;
          break;
      }
    }
```
## 文件夹互传实现

这个功能的开发其实是上架以后很多用户所反馈的需求，到最后这部分的实现还比较复杂。

考虑到如下问题：
当选择了一个有子文件或文件夹的一个文件夹的时候，要如何告知其他端着这所有的文件的下载地址。
最极端的情况，用户选择了路径为 `/` 的文件夹，这个文件夹下有成千上万个子文件，全塞 json 发送，
有很大的几率会丢包。

并且，会存在用户点击选择文件夹后，很长的时间，消息都还没有发出去，可能还正在执行`Directory.list`

所以目前的方案是，先发送简单的消息体告知其它端这是一条文件夹共享的消息。
再告知其他端这个文件夹下的子文件的路径，以及文件总大小。

## 其他消息协议

1. 普通消息
```json
{
    "msgType":"text",
    "content":"消息内容"
}
```
2. 文件消息


{
    "msgType": "file",
    "fileName": "截屏2021-08-01 下午3.39.10.png",
    "filePath": "/Users/nightmare/Desktop/截屏2021-08-01 下午3.39.10.png",
    "fileSize": "92.9K",
    "url": "http://192.168.250.152:13000"
}
```

3. 文件夹消息

web 端的文件消息
```json
{
    "msgType": "webfile",
    "fileName": "截屏2021-08-01 下午3.39.10.png",
}
```

