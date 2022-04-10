import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 预览图片的组件
class PreviewImage extends StatefulWidget {
  const PreviewImage({Key key, this.path}) : super(key: key);
  final String path;
  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: widget.path,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Image.file(
                File(widget.path),
              ),
            ),
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
    );
  }
}
