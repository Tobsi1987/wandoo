import 'dart:ui';

/// Ein Herz der Breite [size], Mitte bei [center].
Path heartPath(Offset center, double size) {
  final w = size;
  final h = size * 0.9;
  final x = center.dx - w / 2;
  final y = center.dy - h / 2;
  return Path()
    ..moveTo(x + w / 2, y + h)
    ..cubicTo(
      x - w * 0.1,
      y + h * 0.55,
      x + w * 0.05,
      y - h * 0.1,
      x + w / 2,
      y + h * 0.25,
    )
    ..cubicTo(
      x + w * 0.95,
      y - h * 0.1,
      x + w * 1.1,
      y + h * 0.55,
      x + w / 2,
      y + h,
    )
    ..close();
}

const heartColor = Color(0xFFEC5F8E);
