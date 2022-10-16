# 速享

Language: 中文简体 | [English](README-EN.md)

![release](https://img.shields.io/github/v/release/nightmare-space/speed_share) 
[![Last Commits](https://img.shields.io/github/last-commit/nightmare-space/speed_share?logo=git&logoColor=white)](https://github.com/nightmare-space/speed_share/commits/master)<!-- [![Pull Requests](https://img.shields.io/github/issues-pr/nightmare-space/speed_share?logo=github&logoColor=white)](https://github.com/nightmare-space/speed_share/pulls) -->
[![Code size](https://img.shields.io/github/languages/code-size/nightmare-space/speed_share?logo=github&logoColor=white)](https://github.com/nightmare-space/speed_share)
[![License](https://img.shields.io/github/license/nightmare-space/speed_share?logo=open-source-initiative&logoColor=green)](https://github.com/nightmare-space/speed_share/blob/master/LICENSE)
 ![Platform](https://img.shields.io/badge/support%20platform-android%20%7C%20web%20%7C%20windows%20%7C%20macos%20%7C%20linux-orange) ![download time](https://img.shields.io/github/downloads/nightmare-space/speed_share/total) ![open issues](https://img.shields.io/github/issues/nightmare-space/speed_share) ![fork](https://img.shields.io/github/forks/nightmare-space/speed_share?style=social) ![code line](https://img.shields.io/tokei/lines/github/nightmare-space/speed_share) ![build](https://img.shields.io/github/workflow/status/nightmare-space/speed_share/SpeedShare%20Publish%20Actions) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/f969750dc4aa424ead664219ddcf321d)](https://app.codacy.com/gh/nightmare-space/speed_share?utm_source=github.com&utm_medium=referral&utm_content=nightmare-space/speed_share&utm_campaign=Badge_Grade)
 [![SpeedShare Publish Actions](https://github.com/nightmare-space/speed_share/actions/workflows/publish.yml/badge.svg)](https://github.com/nightmare-space/speed_share/actions/workflows/publish.yml)

<img src="header.png" width="100%" /> 

这是一款完全基于局域网的文件互传终端，速享不使用任何服务器，不使用您的移动流量，不收集任何用户数据，完全的点对点传输。

可以快速共享文本消息，图片或其他文件，文件夹。

适用于局域网中的文件互传，解决 QQ，微信等上传文件会经过服务器的问题，或者部分测试手机，没有这类聊天软件。

**这是一个纯个人的开源项目，它虽然不及企业级的一些项目一般完整和强大，但我会耐心的完善以及打磨这个产品。**

**注意！！！**

这个仓库仍在开发维护中，但是由于平时工作缘故，所以不会有太多空闲的时间，相关的截图等都没来得及更新，见谅！！！
编译不过联系邮箱 mengyanshou@gmail.com
## 目录

- [速享](#速享)
  - [目录](#目录)
  - [截图](#截图)
  - [功能特性](#功能特性)
  - [浏览器加入](#浏览器加入)
  - [文件共享](#文件共享)
    - [在房间中](#在房间中)
    - [在主页](#在主页)
  - [设置](#设置)
  - [本地文件管理](#本地文件管理)
  - [开发者文档](#开发者文档)

## 截图

<img src="screenshot/v2/home.png" width="32%" /> <img src="screenshot/v2/remote_file.png" width="32%" height="32%" /> <img src="screenshot/v2/file_manager.png" width="32%" height="32%" /> 

<img src="screenshot/v2/file_manager2.png" width="32%" height="32%" />  <img src="screenshot/v2/personal.png" width="32%" height="32%" /> <img src="screenshot/v2/setting.png" width="32%" height="32%" /> 

<img src="screenshot/v2/chat_window.png" width="32%" />


## 功能特性

- 文件互传
  - 像聊天一样在局域网共享文件
  - 断点续传
  - 图片预览，视频极速在线播放
  - 点对点高速下载，不使用服务器中转
  - 多个设备同时分享与查看
  - 文件夹共享（重构中）
- 远程文件管理
  - 可视化浏览
  - 删除，重命名
- 文件分类:将接受到的文件按扩展名进行分类
- 快速连接
  - UDP 自动连接
  - 扫码连接
  - 输入连接
  - 历史连接
- 文件静态部署：类似 tomcat 或者 nginx，方便设备间使用浏览器查看文件，访问网页
- 支持浏览器加入客户端
- 剪切板极速共享
- 支持多平台：Android、Windows、macOS、Linux
- 响应式设计：适配各种尺寸，平板、手机、横竖屏切换自动适配布局
- 支持Android SAF:可以接收任意App分享的文件
- 桌面端后台运行

## 浏览器加入

客户端启动速享后，点击底部导航栏切换到主页，会有一个`远程访问`的卡片，局域网内浏览器打开对应的 url 即可加入共享。

<img src="screenshot/v2/address.jpg" width="50%"/>

## 文件共享
### 在房间中
点击右下角`+`按钮，可选择来自系统文件管理器的文件、速享内部文件管理器的文件到共享窗口。

### 在主页
点击主页`+`号按钮，也可实现如上分享逻辑。

## 设置

速享开放了一些用户设置，目前有以下设置
- 自动下载
- 剪切板共享
- 收到消息振动提醒
- 下载路径切换

通过底部导航栏切换至`我的`页面即可看见设置功能。

<img src="screenshot/v2/setting.png" width="50%" /> 

## 本地文件管理

切换到文件管理页面，会显示速享的接收文件概览，点击右上角切换箭头，即可切换文件管理详情。
<img src="screenshot/v2/file_manager.png" width="50%" height="50%" /> 

<!-- ## 远程文件管理
速享的亮点功能之一，可以远程管理已连接设备的文件，手机端连接到其他设备后，通过底部导航栏可进入远程文件管理器页面。

桌面版视图，点击左边侧栏进入对应的设备聊天窗口，即可远程显示对方设备的文件。
 -->


## 开发者文档

详见 [DEVELOP.md](DEVELOP.md)

