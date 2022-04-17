import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:speed_share/v2/ext_util.dart';

import 'preview_image.dart';

Widget getIconByExt(String path) {
  Widget child;
  if (path.isVideo) {
    child = Image.asset(
      'assets/icon/video.png',
      width: 36.w,
      height: 36.w,
    );
  } else if (path.isPdf) {
    child = Image.asset(
      'assets/icon/pdf.png',
      width: 36.w,
      height: 36.w,
    );
  } else if (path.isDoc) {
    child = Image.asset(
      'assets/icon/doc.png',
      width: 36.w,
      height: 36.w,
    );
  } else if (path.isZip) {
    child = Image.asset(
      'assets/icon/zip.png',
      width: 36.w,
      height: 36.w,
    );
  } else if (path.isAudio) {
    child = Image.asset(
      'assets/icon/mp3.png',
      width: 36.w,
      height: 36.w,
    );
  } else if (path.isImg) {
    return Hero(
      tag: path,
      child: GestureDetector(
        onTap: () {
          Get.to(PreviewImage(
            path: path,
            tag: path,
          ));
        },
        child: path.startsWith('http')
            ? Image(
                width: 36.w,
                height: 36.w,
                fit: BoxFit.cover,
                image: ResizeImage(
                  NetworkImage(path),
                  width: 100,
                ),
              )
            : Image(
                image: ResizeImage(
                  FileImage(File(path)),
                  width: 100,
                ),
                width: 36.w,
                height: 36.w,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  child ??= Image.asset(
    'assets/icon/other.png',
    width: 36.w,
    height: 36.w,
  );
  return GestureDetector(
    onTap: () {
      OpenFile.open(path);
    },
    child: child,
  );
}
