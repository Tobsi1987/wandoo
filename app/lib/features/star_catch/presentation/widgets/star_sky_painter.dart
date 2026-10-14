import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wandoo/features/star_catch/domain/star_rain.dart';

/// Ein kurzes Funkeln, wo ein Stern gefangen wurde.
class Sparkle {
  Sparkle(this.x, this.y);

  final double x;
  final double y;
  double age = 0;
}

/// Malt den Nachthimmel mit fallenden Sternschnuppen und Funkeln.
class StarSkyPainter extends CustomPainter {
  StarSkyPainter({
    required this.stars,
    required this.sparkles,
    required this.time,
  });

  final List<FallingStar> stars;
  final List<Sparkle> sparkles;
  final double time;

  static final List<(double, double, double)> _background = List.generate(40, (
    i,
  ) {
    final r = math.Random(i * 7 + 3);
    return (r.nextDouble(), r.nextDouble() * 0.75, r.nextDouble());
  });

  @override
  void paint(Canvas canvas, Size size) {
    _twinkle(canvas, size);
    for (final star in stars) {
      _shootingStar(canvas, Offset(star.x * size.width, star.y * size.height));
    }
    for (final s in sparkles) {
      _sparkle(canvas, Offset(s.x * size.width, s.y * size.height), s.age);
    }
  }

  void _twinkle(Canvas canvas, Size size) {
    final paint = Paint();
    for (final (x, y, phase) in _background) {
      final glow = 0.35 + 0.35 * math.sin(time * 2 + phase * 6.3);
      paint.color = Colors.white.withValues(alpha: glow);
      canvas.drawCircle(Offset(x * size.width, y * size.height), 1.4, paint);
    }
  }

  void _shootingStar(Canvas canvas, Offset at) {
    final tail = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          const Color(0xFFFFE27A).withValues(alpha: 0.8),
          const Color(0x00FFE27A),
        ],
      ).createShader(Rect.fromLTWH(at.dx - 6, at.dy - 60, 12, 60))
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(at, at.translate(-8, -60), tail)
      ..drawCircle(
        at,
        22,
        Paint()
          ..color = const Color(0x55FFE27A)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      )
      ..drawPath(_starPath(at, 16, 7), Paint()..color = const Color(0xFFFFD84D))
      ..drawPath(_starPath(at, 8, 3.5), Paint()..color = Colors.white);
  }

  void _sparkle(Canvas canvas, Offset at, double age) {
    final paint = Paint()
      ..color = const Color(0xFFFFF1A8).withValues(alpha: 1 - age)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final r = 12 + 40 * age;
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(at + dir * (r * 0.6), at + dir * r, paint);
    }
  }

  static Path _starPath(Offset c, double outer, double inner) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? outer : inner;
      final a = -math.pi / 2 + i * math.pi / 5;
      final p = c + Offset(math.cos(a), math.sin(a)) * r;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(StarSkyPainter old) => true;
}
