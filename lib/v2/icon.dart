import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:get/get.dart';

Widget getIconByExt(String ext) {
  switch (ext) {
    case '.pdf':
      return Image.asset(
        'assets/icon/pdf.png',
        width: 36.w,
        height: 36.w,
      );
      break;
    case '.docx':
      return Image.asset(
        'assets/icon/doc.png',
        width: 36.w,
        height: 36.w,
      );
      break;
    case '.ppt':
      return Image.asset(
        'assets/icon/ppt.png',
        width: 36.w,
        height: 36.w,
      );
      break;
    case '.pptx':
      return Image.asset(
        'assets/icon/ppt.png',
        width: 36.w,
        height: 36.w,
      );
      break;
    case 'other':
      return Image.asset(
        'assets/icon/other.png',
        width: 36.w,
        height: 36.w,
      );
      break;
    case '.zip':
      return Image.asset(
        'assets/icon/zip.png',
        width: 36.w,
        height: 36.w,
      );
      break;
    case '.flac':
      return Image.asset(
        'assets/icon/mp3.png',
        width: 36.w,
        height: 36.w,
      );
      break;
    default:
  }
  return Image.asset(
    'assets/icon/other.png',
    width: 36.w,
    height: 36.w,
  );
}
