import 'package:flutter/material.dart';
// 自定义路由
class CustomRoute extends PageRouteBuilder<void> {
  CustomRoute(this.widget)
      : super(
          // 设置过度时间
          transitionDuration: const Duration(milliseconds: 200),
          // 构造器
          pageBuilder: (
            // 上下文和动画
            BuildContext context,
            Animation<double> animation,
            Animation<double> _,
          ) {
            return widget;
          },
          opaque: false,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> _,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
  final Widget widget;
}
