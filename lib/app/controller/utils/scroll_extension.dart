import 'package:flutter/material.dart';

extension Scroll on ScrollController {
  Future<void> scrollToEnd() async {
    // 让listview滚动到底部
    await Future.delayed(const Duration(milliseconds: 100));
    if (hasClients) {
      animateTo(
        position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease,
      );
    }
  }
}
