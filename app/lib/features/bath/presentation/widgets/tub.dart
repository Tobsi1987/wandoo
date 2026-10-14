import 'package:flutter/material.dart';

/// Eine runde Holzwanne mit Wasser, vor der das Wesen steht.
class Tub extends StatelessWidget {
  const Tub({required this.width, super.key});

  final double width;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(width, width * 0.38), painter: _TubPainter());
}

class _TubPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final body = Path()
      ..moveTo(0, h * 0.18)
      ..quadraticBezierTo(w * 0.04, h, w * 0.5, h)
      ..quadraticBezierTo(w * 0.96, h, w, h * 0.18)
      ..close();
    canvas
      ..drawPath(body, Paint()..color = const Color(0xFFB07A4A))
      ..drawOval(
        Rect.fromLTWH(0, 0, w, h * 0.36),
        Paint()..color = const Color(0xFF8C5A33),
      )
      ..drawOval(
        Rect.fromLTWH(w * 0.04, h * 0.05, w * 0.92, h * 0.27),
        Paint()..color = const Color(0xFF9FD8F2),
      );
    final band = Paint()
      ..color = const Color(0xFF6D4528)
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.06;
    canvas
      ..save()
      ..clipPath(body);
    for (final y in [0.5, 0.8]) {
      canvas.drawLine(Offset(0, h * y), Offset(w, h * y), band);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_TubPainter old) => false;
}
