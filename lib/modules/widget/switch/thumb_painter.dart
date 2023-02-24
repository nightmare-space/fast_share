part of xlive_switch;

class _XliveThumbPainter {
  _XliveThumbPainter({
    required this.color,
    this.shadowColor = const Color(0x00FFFFFF),
  }) : _shadowPaint = BoxShadow(
          color: shadowColor,
          blurRadius: 1.0,
        ).toPaint();

  final Color color;

  final Color shadowColor;

  final Paint _shadowPaint;

  static const double radius = 14.0;

  // static const double extension = 7.0;

  void paint(Canvas canvas, Rect rect) {
    final RRect rrectParent = RRect.fromRectAndRadius(
      rect.deflate(4.0),
      Radius.circular(rect.shortestSide / 2.0),
    );

    final RRect childRect = RRect.fromRectAndRadius(
      rect.deflate(10.0),
      Radius.circular(rect.shortestSide / 2.0),
    );

    canvas.drawDRRect(rrectParent, childRect, _shadowPaint);
    canvas.drawDRRect(rrectParent.shift(const Offset(0.0, 3.0)),
        childRect.shift(const Offset(0.0, 3.0)), _shadowPaint);
    canvas.drawDRRect(
        RRect.fromLTRBR(
          rrectParent.left,
          rrectParent.top,
          rrectParent.right,
          rrectParent.bottom,
          Radius.circular(rect.shortestSide / 2.0),
        ),
        childRect,
        Paint()..color = color);
  }
}