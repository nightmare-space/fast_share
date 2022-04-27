# 速享

Language: 中文简体 | [English](README-EN.md)

![release](https://img.shields.io/github/v/release/nightmare-space/speed_share) 
[![Last Commits](https://img.shields.io/github/last-commit/nightmare-space/speed_share?logo=git&logoColor=white)](https://github.com/nightmare-space/speed_share/commits/master)
[![Pull Requests](https://img.shields.io/github/issues-pr/nightmare-space/speed_share?logo=github&logoColor=white)](https://github.com/nightmare-space/speed_share/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/nightmare-space/speed_share?logo=github&logoColor=white)](https://github.com/nightmare-space/speed_share)
[![License](https://img.shields.io/github/license/nightmare-space/speed_share?logo=open-source-initiative&logoColor=green)](https://github.com/nightmare-space/speed_share/blob/master/LICENSE)
 ![Platform](https://img.shields.io/badge/support%20platform-android%20%7C%20web%20%7C%20windows%20%7C%20macos%20%7C%20linux-orange) ![download time](https://img.shields.io/github/downloads/nightmare-space/speed_share/total) ![open issues](https://img.shields.io/github/issues/nightmare-space/speed_share) ![fork](https://img.shields.io/github/forks/nightmare-space/speed_share?style=social) ![code line](https://img.shields.io/tokei/lines/github/nightmare-space/speed_share) ![build](https://img.shields.io/github/workflow/status/nightmare-space/speed_share/SpeedShare%20Publish%20Actions) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/f969750dc4aa424ead664219ddcf321d)](https://app.codacy.com/gh/nightmare-space/speed_share?utm_source=github.com&utm_medium=referral&utm_content=nightmare-space/speed_share&utm_campaign=Badge_Grade)

这是一款完全基于局域网的文件互传终端，速享不使用任何服务器，不使用您的移动流量，不收集任何用户数据，完全的点对点传输。

可以快速共享文本消息，图片或其他文件，文件夹。

适用于局域网中的文件互传，解决 QQ，微信等上传文件会经过服务器的问题，或者部分测试手机，没有这类聊天软件。

## 注意！！！

这个仓库仍在开发维护中，但是由于平时工作缘故，所以不会有太多空闲的时间，相关的截'图等都没来得及更新，见谅！！！
编译不过联系 QQ:906262255，注明来意~

## 帮助开发

呜呜呜一个人有点写不动，最近来了一位设计师@柚凛，出了整套速享的设计图，我准备直接将速享版本更新到2.0。

但是产品在整体设计上调整较多，开发量也较大，如果有任何的 Flutter 开发者愿意帮忙开发，联系QQ 906262255，呜呜呜~

## 说明

这是一个纯个人的开源项目，它虽然不及企业级的一些项目一般完整和强大，但我会耐心的完善以及打磨这个产品。

## 截图

<img src="https://raw.githubusercontent.com/nightmare-space/speed_share/main/screenshot/easy.jpg" width="30%" height="30%" /> <img src="https://raw.githubusercontent.com/nightmare-space/speed_share/main/screenshot/connect.jpg" width="30%" height="30%" /> <img src="https://raw.githubusercontent.com/nightmare-space/speed_share/main/screenshot/down.jpg" width="30%" height="30%" />

## 下载

- [个人服务器下载地址](http://nightmare.fun/YanTool/resources/SpeedShare/?C=N;O=A)

改项目集成了 Github Action 来提供自动打包的功能，然后使用``进行包的上传，

## 功能列表

- 类似于 nginx 和 tomcat 的文件部署。
- 局域网设备发现，快速加入共享。
- 像聊天一样在局域网共享文件，点对点连接，不使用服务器中转。
- 支持图片以及视频消息直接预览（视频预览仅支持 Android 与 Web ），快速缓冲。
- 支持断点续传
- 支持多个设备同时分享与查看
- 文件夹共享
- 浏览器快速加入共享
- 历史消息获取


## 局域网发现
发现其他设备启动速享后，主页顶部会出现提示，如图：

<img src="screenshot/v2/broadcast.jpg" width="50%" height="50%" /> 
点击√即可加入共享房间~

## 文件共享
在房间中或者主页时，

## 设置
速享开放了一些用户设置，目前有以下设置
- 自动下载
- 剪切板共享
- 收到消息振动提醒
- 下载路径切换

## 本地文件管理
切换到文件管理页面，会显示速享的接收文件概览，点击右上角切换箭头，即可切换文件管理详情。
<img src="screenshot/v2/file_manager.png" width="50%" height="50%" /> 

## 远程文件管理
速享的亮点功能之一，可以远程管理已连接设备的文件，手机端连接到其他设备后，通过底部导航栏可进入远程文件管理器页面。

桌面版视图，点击左边侧栏进入对应的设备聊天窗口，即可远程显示对方设备的文件。



## 开发者文档

详见 [DEVELOP.md](DEVELOP.md

## Q&A
### WEB端如何使用?
web端不能单独打开速享(从实现来看是可以，但我并不想这么做)，打开物理客户端后，主页会提示远程访问的地址，使用浏览器打开即可。
点击浮动按钮，即可在浏览器上远程管理对应设备的文件

### 希望能自定义开发路径
设置预留了，还在开发中

### 没有以前简洁了，交互上有很大问题，首次使用界面全是空白，我不去点一下那“全部设备”都不知道原来的传输界面在哪
你使用的是预发布版本

### 规范一下目录把，要么自定义要么放Download去
设置预留了

### pc端UI会同步更改吗？
肯定会的，时间没那么多

### UI和操作感觉没有以前简洁明了，现在搞的稍微有点麻烦
1.你用的是测试版
2.我不可能满足所有用户，只能在实用与简介之间找到一个平衡

###请问上个版本是稳定的吗
每个版本都不稳定

### 电脑端是浏览器输入什么链接后才能连手机端，原来能看见，更新2.0后没了
你用的是测试版

### 在哪下载Windows
1.github actions
2.nightmare.fun官网

### iOS会有吗
目前买不上iOS证书，后续有计划，近一年别想

### TV端安装不了，老机型报错
去官网找arm版本

### 速度慢，不及MIUI+
你可以去用MIUI+，其次MIUI+会使用隐性的热点，也就是说你用热点靠近点互传可能就没这个问题。

### UI及交互问题
你用的是测试版

### 读剪切板过分了吧？
剪切板功能是其它N个人的建议，卸载解决

### 浏览器往物理设备传文件的问题
这个实现很复杂，尽量用多个客户端

### 后台断连
可算BUG，但是目前没精力分析问题在哪，后面解决

### 内置文件管理器空白
估计是魅族魔改底层导致的，先用系统文件管理器选文件

### 系统文件管理器和内置文件管理器选文件有差别吗
有，系统文件管理器无论选择任何文件，都会拷贝一份到内置目录，所以选大文件会卡，而内置文件管理器不会

### 系统分享文件到速享，不会自动发送
BUG，后面有精力再解决

不得不说有的人三明治说话法学得挺好啊
如:
“*的这软件跟屎一样
ok卸载了
哦对了红红头像好评”
？？？