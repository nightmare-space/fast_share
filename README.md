# Speed Share

Language: English | [中文简体](README-ZH.md)

![release](https://img.shields.io/github/v/release/nightmare-space/speed_share) 
[![Last Commits](https://img.shields.io/github/last-commit/nightmare-space/speed_share?logo=git&logoColor=white)](https://github.com/nightmare-space/speed_share/commits/master)<!-- [![Pull Requests](https://img.shields.io/github/issues-pr/nightmare-space/speed_share?logo=github&logoColor=white)](https://github.com/nightmare-space/speed_share/pulls) -->
[![Code size](https://img.shields.io/github/languages/code-size/nightmare-space/speed_share?logo=github&logoColor=white)](https://github.com/nightmare-space/speed_share)
[![License](https://img.shields.io/github/license/nightmare-space/speed_share?logo=open-source-initiative&logoColor=green)](https://github.com/nightmare-space/speed_share/blob/master/LICENSE)
 ![Platform](https://img.shields.io/badge/support%20platform-android%20%7C%20web%20%7C%20windows%20%7C%20macos%20%7C%20linux-orange) ![download time](https://img.shields.io/github/downloads/nightmare-space/speed_share/total) ![open issues](https://img.shields.io/github/issues/nightmare-space/speed_share) ![fork](https://img.shields.io/github/forks/nightmare-space/speed_share?style=social) ![code line](https://img.shields.io/tokei/lines/github/nightmare-space/speed_share) ![build](https://img.shields.io/github/workflow/status/nightmare-space/speed_share/SpeedShare%20Publish%20Actions) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/f969750dc4aa424ead664219ddcf321d)](https://app.codacy.com/gh/nightmare-space/speed_share?utm_source=github.com&utm_medium=referral&utm_content=nightmare-space/speed_share&utm_campaign=Badge_Grade)


- [Speed Share](#speed-share)
  - [Notice](#notice)
  - [Screenshots](#screenshots)
  - [Features](#features)
  - [Developer Documentation](#developer-documentation)

This is a completely LAN-based file transfer terminal. Speed Share does not use any servers, does not consume your mobile data, and does not collect any user data. It enables peer-to-peer transmission.

You can quickly share text messages, images, or other files and folders.

It is suitable for LAN file transfer, solving the problem of files being routed through servers in applications like QQ and WeChat.

## Notice

This repository is still under development and maintenance. However, due to my regular work, I do not have much free time, and I haven't had the opportunity to update related screenshots, etc. I apologize for the inconvenience!

Since I started my full-time job, I no longer have a lot of energy to invest in open-source projects.

If you encounter build issues, please contact me at mengyanshou@gmail.com.

## Screenshots

<img src="screenshot/v2/home.png" width="32%" /> <img src="screenshot/v2/remote_file.png" width="32%" height="32%" /> <img src="screenshot/v2/file_manager.png" width="32%" height="32%" /> 

<img src="screenshot/v2/file_manager2.png" width="32%" height="32%" />  <img src="screenshot/v2/personal.png" width="32%" height="32%" /> <img src="screenshot/v2/setting.png" width="32%" height="32%" /> 

<img src="screenshot/v2/chat_window.png" width="32%" />


## Features

- File Transfer
  - Share files over LAN like chatting
  - Resume interrupted transfers
  - Image preview, fast online video playback
  - Peer-to-peer high-speed downloading, no server relaying
  - Simultaneous sharing and viewing on multiple devices
  - Folder sharing (under reconstruction)
- Remote File Management
  - Visual browsing
  - Delete, rename
- File categorization: Classify received files by extension
- Quick Connections
  - UDP automatic connection
  - Scan QR code to connect
  - Manual input connection
  - Historical connections
- File static deployment: Similar to Tomcat or Nginx, allowing devices to use browsers to view files and access web pages
- Support for browser joining as clients
- Clipboard sharing
- Multi-platform support: Android, Windows, macOS, Linux
- Responsive design: Adapt to various screen sizes, automatic layout adaptation for tablets, smartphones, and landscape/portrait orientation switching
- Support for Android SAF: Can receive files shared by any app
- Background running on desktop

## Developer Documentation

See [DEVELOP.md](docs/DEVELOP.md) for detailed information.
