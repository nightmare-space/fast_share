import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageWrapper extends StatefulWidget {
  const ImageWrapper({Key key}) : super(key: key);

  @override
  State<ImageWrapper> createState() => _ImageWrapperState();
}

class _ImageWrapperState extends State<ImageWrapper> {
  Uint8List uint8list;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    try {
      Response<Uint8List> response = await Dio().get<Uint8List>(
        'http://nightmare.press/YanTool/image/hong.jpg',
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      uint8list = response.data;
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (uint8list == null) return Placeholder();
    return Image.memory(uint8list);
  }
}
