import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/themes/app_colors.dart';

class WaterRipple extends StatefulWidget {
  const WaterRipple({
    Key key,
    this.count = 2,
  }) : super(key: key);

  final int count;
  @override
  _WaterRippleState createState() => _WaterRippleState();
}

class _WaterRippleState extends State<WaterRipple>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> progress;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );
    progress = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    progress.addListener(() {
      setState(() {});
    });
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        return Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CustomPaint(
              painter: WaterRipplePainter(
                progress.value,
                count: 3,
                color: Colors.indigoAccent,
              ),
            ),
          ),
        );
      },
    );
  }
}

class WaterRipplePainter extends CustomPainter {
  WaterRipplePainter(this.progress,
      {this.count = 3, this.color = const Color(0xFF0080ff)});
  final double progress;
  final int count;
  final Color color;

  final Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width;
    // print(radius);
    for (int i = 0; i < count; i++) {
      double opacity = 1.0;
      if (i != 0) {
        opacity = 0.5 - 0.1 * i;
      }
      double _radius = radius;
      if (i == 0) {
        _radius = radius + 140 * (i + 1) * progress;
      }
      if (i > 0) {
        if (progress > 0.4) {
          _radius = radius + 140 * (i + 1) * progress;
        } else {
          _radius = radius + 140 * (i + 1) * progress;
          opacity = opacity * progress / 0.4;
        }
      }
      final Color _color = color.withOpacity(opacity);
      _paint.color = _color;
      // print(_radius);
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        _radius,
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
