import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:speed_share/v2/ext_util.dart';

Widget getIconByExt(String path) {
  Widget child;
  if (path.isVideo) {
    child = Image.asset(
      'assets/icon/video.png',
      width: 36.w,
      height: 36.w,
    );
  } else if (path.isDoc) {
    child = Image.asset(
      'assets/icon/doc.png',
      width: 36.w,
      height: 36.w,
    );
  } else if (path.isPdf) {
    child = Image.asset(
      'assets/icon/pdf.png',
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
          Get.to(
            Material(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Hero(
                    tag: path,
                    child: Image.file(File(path)),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        child: Image.file(
          File(path),
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
