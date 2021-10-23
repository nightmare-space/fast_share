# 开发者文档

速享使用 websocket 构建了基于聊天服务器(由 get_server 搭建)的文件共享窗口，文件部署使用的是 shelf 相关的库。
聊天窗口发送的为 Json 类型的消息，根据不同的消息类型用不同的字段进行区分。
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
│   └── global.dart # 全局单例，用来发现设备
├── main.dart # app 启动入口文件
├── pages
│   ├── dialog # 弹窗相关页面
│   ├── home_page.dart # 主页显示文件夹
│   ├── item # 聊天页面的 item 组件所在的文件夹
│   ├── model # 聊天相关的 model
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
│   ├── auth.dart
│   ├── chat_server.dart
│   ├── document
│   ├── http
│   ├── process_server.dart
│   ├── proxy.dart
│   ├── scan_util.dart
│   ├── shelf
│   ├── shelf_static.dart
│   ├── string_extension.dart
│   └── utils.dart
└── widgets
    └── circle_animation.dart # 主页那个动画
```
## 文件互传实现

速享的文件共享分三部步：

**1. 静态部署选择的文件**

这部分更多是后端的知识，但理解起来不难，以文件的完整路径为 url 响应对应的文件内容即可。
速享并不关心自己何时需要发送文件，例如下载服务器上部署的文件，服务器只需要监听、响应，不关心具体何时进行发送。

**2. 发送聊天消息，并带上文件的路径，和本机所在的ip 列表**

与其他文件共享不一样，速享只是告诉其他它端应该从哪儿下到这个文件，而不是直接发送。
其他的根据消息中所包含的 IP 列表与自身 IP 进行比较，计算出文件的下载地址，
这个计算逻辑也并不复杂，目前仅仅是通过网络号进行了简单的过滤、拼接。

**3. 其它端发起 Get 请求下载文件**

## 文件夹互传实现
这个功能的开发其实是上架以后很多用户所反馈的需求，到最后这部分的实现还比较复杂。

考虑到如下问题：
当选择了一个有子文件或文件夹的一个文件夹的时候，要如何告知其他端着这所有的文件的下载地址。
最极端的情况，用户选择了路径为 `/` 的文件夹，这个文件夹下有成千上万个子文件，全塞 Json 发送，
有很大的几率会丢包的。

并且，会存在用户点击选择文件夹后，很长的时间，消息都还没有发出去，可能还正在执行Directory.list

所以目前的方案是，先发送简单的消息体告知其它端这是一条文件夹共享的消息。
再告知其他端这个文件夹下的子文件的路径，以及文件总大小。

## 消息协议

1. 普通消息
```json
{
    "msgType":"text",
    "content":"消息内容"
}
```
2. 文件消息

```json
{
    "msgType":"file",
    "fileName":"文件名",
    "filePath":"文件路径",
    "fileSize":"文件大小",
    "url":"发送端的url"
}
```

3. 文件夹消息

