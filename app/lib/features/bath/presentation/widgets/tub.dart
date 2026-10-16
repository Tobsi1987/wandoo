import 'package:flutter/material.dart';

/// Eine runde Holzwanne in zwei Hälften: [Tub.back] liegt hinter dem Wesen
/// (Rand und Wasserfläche), [Tub.front] davor (Wasser, Schaum und Wand).
/// So sitzt das Wesen wirklich im Wasser statt hinter der Wanne.
class Tub extends StatelessWidget {
  const Tub.back({required this.width, super.key}) : front = false;
  const Tub.front({required this.width, super.key}) : front = true;

  final double width;
  final bool front;

  /// Höhe der Wanne im Verhältnis zur Breite.
  static const ratio = 0.5;

  /// Wo die Wasserlinie liegt, als Anteil der Höhe von oben.
  static const waterAt = 0.17;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(width, width * ratio),
    painter: front ? _FrontPainter() : _BackPainter(),
  );
}

const _rim = Color(0xFF8C5A33);
const _wood = Color(0xFFB07A4A);
const _band = Color(0xFF6D4528);
const _water = Color(0xFF8FD0EE);

Rect _rimRect(Size s) => Rect.fromLTWH(0, 0, s.width, s.height * 0.34);
Rect _waterRect(Size s) => Rect.fromLTWH(
  s.width * 0.05,
  s.height * 0.05,
  s.width * 0.9,
  s.height * 0.24,
);

class _BackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..drawOval(_rimRect(size), Paint()..color = _rim)
      ..drawOval(_waterRect(size), Paint()..color = _water);
  }

  @override
  bool shouldRepaint(_BackPainter old) => false;
}

class _FrontPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final water = _waterRect(size);
    // Vordere Hälfte der Wasserfläche: halb durchsichtig über dem Bauch.
    canvas
      ..save()
      ..clipRect(Rect.fromLTRB(0, water.center.dy, w, h))
      ..drawOval(water, Paint()..color = _water.withValues(alpha: 0.85))
      ..restore();
    _foam(canvas, water);
    final body = Path()
      ..moveTo(0, h * 0.17)
      ..arcTo(_rimRect(size), 3.1416, -3.1416, false)
      ..lineTo(w, h * 0.17)
      ..quadraticBezierTo(w * 0.97, h, w * 0.5, h)
      ..quadraticBezierTo(w * 0.03, h, 0, h * 0.17)
      ..close();
    canvas.drawPath(body, Paint()..color = _wood);
    final band = Paint()
      ..color = _band
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.05;
    canvas
      ..save()
      ..clipPath(body);
    for (final y in [0.55, 0.82]) {
      canvas.drawLine(Offset(0, h * y), Offset(w, h * y), band);
    }
    // Vorderer Rand als dunkler Bogen.
    canvas
      ..restore()
      ..drawArc(
        _rimRect(size).deflate(h * 0.02),
        0,
        3.1416,
        false,
        Paint()
          ..color = _rim
          ..style = PaintingStyle.stroke
          ..strokeWidth = h * 0.06,
      );
  }

  /// Schaumberge entlang der vorderen Wasserlinie, weich schattiert.
  void _foam(Canvas canvas, Rect water) {
    final r = water.height * 0.3;
    for (var i = 0; i < 14; i++) {
      final t = i / 13;
      final x = water.left + water.width * (0.06 + 0.88 * t);
      final dip = 1 - (2 * t - 1) * (2 * t - 1);
      final y =
          water.center.dy + water.height * 0.36 * dip - (i.isOdd ? r * 0.5 : 0);
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
  bool shouldRepaint(_FrontPainter old) => false;
}
