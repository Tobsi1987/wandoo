import 'package:flutter/material.dart';

/// Wasser und Schaum in der Wanne, passend zum Bild von `Tub`.
/// Hinten die Wasserfläche, vorne ein durchsichtiger Streifen über dem
/// Bauch und Schaum entlang des Rands.
class TubWater extends CustomPainter {
  const TubWater({required this.front});

  final bool front;

  /// Vorderer Rand in der Mitte, als Anteil der Höhe.
  static const rimAt = 0.5;

  /// Die Wasserfläche als Anteile von Breite und Höhe.
  static const ({double left, double top, double right, double bottom}) _water =
      (left: 0.2, top: 0.22, right: 0.8, bottom: 0.48);

  static const _blue = Color(0xFF8FD0EE);

  @override
  void paint(Canvas canvas, Size size) {
    final water = Rect.fromLTRB(
      size.width * _water.left,
      size.height * _water.top,
      size.width * _water.right,
      size.height * _water.bottom,
    );
    if (!front) {
      canvas.drawOval(water, Paint()..color = _blue);
      return;
    }
    canvas
      ..save()
      ..clipRect(Rect.fromLTRB(0, water.center.dy, size.width, size.height))
      ..drawOval(water, Paint()..color = _blue.withValues(alpha: 0.8))
      ..restore();
    _foam(canvas, water);
  }

  /// Schaumberge entlang der vorderen Wasserlinie, weich schattiert.
  void _foam(Canvas canvas, Rect water) {
    final r = water.height * 0.22;
    for (var i = 0; i < 14; i++) {
      final t = i / 13;
      final x = water.left + water.width * (0.04 + 0.92 * t);
      final dip = 1 - (2 * t - 1) * (2 * t - 1);
      final y =
          water.center.dy + water.height * 0.4 * dip - (i.isOdd ? r * 0.5 : 0);
      final size = r * (0.7 + 0.5 * ((i * 7) % 5) / 4);
      final c = Offset(x, y);
      canvas.drawCircle(
        c,
        size,
        Paint()
          ..shader = const RadialGradient(
            center: Alignment(-0.4, -0.5),
            colors: [Color(0xFFFFFFFF), Color(0xFFDCEFF8)],
          ).createShader(Rect.fromCircle(center: c, radius: size)),
      );
    }
  }

  @override
  bool shouldRepaint(TubWater old) => old.front != front;
}
