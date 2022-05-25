
import 'package:flutter/material.dart';
/// 水波纹动画
/// Create by Nightmare

class WaterRipple extends StatefulWidget {
  const WaterRipple({
    Key key,
    this.count = 2,
  }) : super(key: key);

  final int count;
  @override
  State createState() => _WaterRippleState();
}

class _WaterRippleState extends State<WaterRipple>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> progress;

  AnimationController _outController;
  Animation<double> outProgress;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );
    progress = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _outController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1800,
      ),
    );
    outProgress = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _outController,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
    _controller.addListener(() {
      if (progress.value > 0.8 && !_outController.isAnimating) {
        _outController.reset();
        _outController.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
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
        ),
        AnimatedBuilder(
          animation: outProgress,
          builder: (context, child) {
            return Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CustomPaint(
                  painter: OutWaterRipplePainter(
                    outProgress.value,
                    color: Colors.indigoAccent,
                  ),
                ),
              ),
            );
          },
        ),
      ],
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
  double addWidth = 60;
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width;
    // print(radius);
    for (int i = 0; i < count; i++) {
      double opacity = 1.0;
      if (i != 0) {
        // 越外面的圈越透明
        opacity = 0.5 - 0.1 * i;
      }
      double drawRadius = radius;
      if (i == 0) {
        drawRadius = radius + addWidth * (i + 1) * progress;
      }
      if (i > 0) {
        if (progress > 0.4) {
          drawRadius = radius + addWidth * (i + 1) * progress;
        } else {
          drawRadius = radius + addWidth * (i + 1) * progress;
          opacity = opacity * progress / 0.4;
        }
      }
      final Color drawColor = color.withOpacity(opacity);
      _paint.color = drawColor;
      // print(_radius);
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        drawRadius,
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class OutWaterRipplePainter extends CustomPainter {
  OutWaterRipplePainter(
    this.progress, {
    this.color = const Color(0xFF0080ff),
  });
  final double progress;
  final Color color;

  final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    // final double radius = size.width;
    _paint.color = color.withOpacity(0.3);
    // print(radius);
    double outRadius = (size.width + 180 + 20);
    if (progress < 0.2) {
      _paint.color = color.withOpacity(0.3 * progress / 0.2);
      // outRadius += 200 * (progress - 0.8) / 0.2;
    } else {
      outRadius += (progress - 0.2) / 0.8 * 500;
    }
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      outRadius,
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
