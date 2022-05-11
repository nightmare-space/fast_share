// 用来快速判断文件的类型
extension Ext on String {
  bool get isAudio {
    return endsWith('.mp3') || endsWith('.flac');
  }

  bool get isVideo {
    return endsWith('.mp4') ||
        endsWith('.mkv') ||
        endsWith('.mov') ||
        endsWith(".avi") ||
        endsWith(".wmv") ||
        endsWith(".rmvb") ||
        endsWith(".mpg") ||
        endsWith(".3gp");
  }

  bool get isApk {
    return endsWith('.apk');
  }

  bool get isImg {
    return endsWith('.gif') ||
        endsWith('.jpg') ||
        endsWith('.jpeg') ||
        endsWith('.png') ||
        endsWith('.webp');
  }

  bool get isDoc {
    return endsWith('.doc') ||
        endsWith('.docx') ||
        endsWith('.ppt') ||
        endsWith('.pptx') ||
        endsWith('.pdf');
  }

  bool get isPdf {
    return endsWith('.pdf');
  }

  bool get isZip {
    return endsWith('.zip') || endsWith('.7z') || endsWith('.rar');
  }

  String get getType {
    if (isAudio) {
      return '音乐';
    } else if (isVideo) {
      return '视频';
    } else if (isImg) {
      return '图片';
    } else if (isPdf || isDoc) {
      return '文档';
    } else if (isZip) {
      return '压缩包';
    } else if (isApk) {
      return '安装包';
    }
    return '未知';
  }
}
