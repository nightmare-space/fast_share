# 速享

Language: 中文简体 | [English](README-EN.md)

![release](https://img.shields.io/github/v/release/nightmare-space/speed_share) 
[![Last Commits](https://img.shields.io/github/last-commit/nightmare-space/speed_share?logo=git&logoColor=white)](https://github.com/nightmare-space/speed_share/commits/master)<!-- [![Pull Requests](https://img.shields.io/github/issues-pr/nightmare-space/speed_share?logo=github&logoColor=white)](https://github.com/nightmare-space/speed_share/pulls) -->
[![Code size](https://img.shields.io/github/languages/code-size/nightmare-space/speed_share?logo=github&logoColor=white)](https://github.com/nightmare-space/speed_share)
[![License](https://img.shields.io/github/license/nightmare-space/speed_share?logo=open-source-initiative&logoColor=green)](https://github.com/nightmare-space/speed_share/blob/master/LICENSE)
 ![Platform](https://img.shields.io/badge/support%20platform-android%20%7C%20web%20%7C%20windows%20%7C%20macos%20%7C%20linux-orange) ![download time](https://img.shields.io/github/downloads/nightmare-space/speed_share/total) ![open issues](https://img.shields.io/github/issues/nightmare-space/speed_share) ![fork](https://img.shields.io/github/forks/nightmare-space/speed_share?style=social) ![code line](https://img.shields.io/tokei/lines/github/nightmare-space/speed_share) ![build](https://img.shields.io/github/workflow/status/nightmare-space/speed_share/SpeedShare%20Publish%20Actions) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/f969750dc4aa424ead664219ddcf321d)](https://app.codacy.com/gh/nightmare-space/speed_share?utm_source=github.com&utm_medium=referral&utm_content=nightmare-space/speed_share&utm_campaign=Badge_Grade)


- [速享](#速享)
  - [注意](#注意)
  - [截图](#截图)
  - [功能特性](#功能特性)
  - [开发者文档](#开发者文档)

这是一款完全基于局域网的文件互传终端，速享不使用任何服务器，不使用您的移动流量，不收集任何用户数据，完全的点对点传输。

可以快速共享文本消息，图片或其他文件，文件夹。

适用于局域网中的文件互传，解决 QQ，微信等上传文件会经过服务器的问题，或者部分测试手机，没有这类聊天软件。

## 注意

这个仓库仍在开发维护中，但是由于平时工作缘故，所以不会有太多空闲的时间，相关的截图等都没来得及更新，见谅！！！

自从正式入职后，我便不再有大量的精力能够投入到开源项目中，

我认为它的价值应该和 LocalSend 一样，但我的工作让我不再有太多的精力去维护众多的开源库。

编译不过联系邮箱 mengyanshou@gmail.com

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

## 开发者文档

详见 [DEVELOP.md](docs/DEVELOP.md)

