import 'package:flutter/material.dart';

/// Die gemütliche Höhle hinter den Möbeln: Felswand, rundes Fenster,
/// ein Regalbrett rechts und ein heller Boden.
class CaveBackdrop extends CustomPainter {
  const CaveBackdrop({required this.night, required this.floorAt});

  final bool night;

  /// Wo die Wand in den Boden übergeht, als Anteil der Höhe.
  final double floorAt;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;
    final floorY = h * floorAt;
    canvas
      ..drawRect(rect, Paint()..color = _c(0xFF5B3B26, 0xFF241A22))
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          w * 0.03,
          h * 0.02,
          w * 0.97,
          floorY + 20,
          topLeft: Radius.circular(w * 0.45),
          topRight: Radius.circular(w * 0.45),
        ),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_c(0xFFE9C79A, 0xFF4A3B52), _c(0xFFD7A874, 0xFF3A2E44)],
          ).createShader(rect),
      );
    _window(canvas, Offset(w * 0.5, h * 0.17), w * 0.11);
    _floor(canvas, size, floorY);
    // Regalbrett für das Licht.
    canvas.drawRRect(
      RRect.fromLTRBR(
        w * 0.68,
        h * 0.335,
        w * 0.95,
        h * 0.355,
        const Radius.circular(4),
      ),
      Paint()..color = _c(0xFF9C6B3F, 0xFF5E4536),
    );
  }

  void _window(Canvas canvas, Offset center, double r) {
    canvas
      ..drawCircle(center, r + 6, Paint()..color = _c(0xFFB07A45, 0xFF5E4536))
      ..drawCircle(center, r, Paint()..color = _c(0xFF9FD3F5, 0xFF1C2550));
    if (night) {
      canvas
        ..drawCircle(
          center + Offset(r * 0.25, -r * 0.2),
          r * 0.35,
          Paint()..color = const Color(0xFFFFF1B8),
        )
        ..drawCircle(
          center + Offset(r * 0.4, -r * 0.3),
          r * 0.3,
          Paint()..color = const Color(0xFF1C2550),
        );
    } else {
      canvas
        ..drawCircle(
          center + Offset(-r * 0.2, r * 0.25),
          r * 0.35,
          Paint()..color = Colors.white,
        )
        ..drawCircle(
          center + Offset(r * 0.2, r * 0.3),
          r * 0.3,
          Paint()..color = Colors.white,
        );
    }
  }

  void _floor(Canvas canvas, Size size, double y) {
    final floor = Rect.fromLTRB(0, y, size.width, size.height);
    canvas.drawRect(
      floor,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_c(0xFFC28A55, 0xFF4B3A40), _c(0xFFDDAA72, 0xFF5A4650)],
        ).createShader(floor),
    );
    final line = Paint()
      ..color = _c(0x22000000, 0x33000000)
      ..strokeWidth = 2;
    for (var i = 1; i < 5; i++) {
      final ly = y + (size.height - y) * i / 5;
      canvas.drawLine(Offset(0, ly), Offset(size.width, ly), line);
    }
  }

  Color _c(int day, int nightColor) => Color(night ? nightColor : day);

  @override
  bool shouldRepaint(CaveBackdrop old) =>
      old.night != night || old.floorAt != floorAt;
}
