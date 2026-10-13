import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wandoo/features/world/domain/weather.dart';
import 'package:wandoo/features/world/domain/world_state.dart';

/// Zeichnet Himmel und Wetter; [clock] läuft einmal pro Minute von 0 bis 1.
class WeatherPainter extends CustomPainter {
  WeatherPainter({required this.world, required this.clock})
    : super(repaint: clock);

  final WorldState world;
  final Animation<double> clock;

  double get _t => clock.value * 60;

  @override
  void paint(Canvas canvas, Size size) {
    if (world.night) _stars(canvas, size);
    switch (world.weather) {
      case Weather.rain:
        _rain(canvas, size, 40);
      case Weather.storm:
        _rain(canvas, size, 70);
        _flash(canvas, size);
      case Weather.snow:
        _snow(canvas, size);
      case Weather.fog:
        _fog(canvas, size);
      case Weather.clear when !world.night:
        _sun(canvas, size);
      case Weather.clear || Weather.cloudy || null:
        break;
    }
  }

  void _stars(Canvas canvas, Size size) {
    final random = Random(7);
    final paint = Paint();
    for (var i = 0; i < 40; i++) {
      final twinkle = 0.5 + 0.5 * sin(_t * 2 + i);
      paint.color = Colors.white.withValues(alpha: 0.25 + 0.5 * twinkle);
      final p = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height * 0.6,
      );
      canvas.drawCircle(p, 1 + random.nextDouble() * 1.5, paint);
    }
    final moon = Offset(size.width * 0.82, size.height * 0.12);
    final crescent = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: moon, radius: 18)),
      Path()..addOval(
        Rect.fromCircle(center: moon + const Offset(8, -5), radius: 16),
      ),
    );
    canvas.drawPath(crescent, Paint()..color = const Color(0xFFFFF4C2));
  }

  void _rain(Canvas canvas, Size size, int drops) {
    final random = Random(3);
    final paint = Paint()
      ..color = const Color(0x8873A9D9)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < drops; i++) {
      final x = random.nextDouble() * size.width;
      final speed = 0.6 + random.nextDouble() * 0.4;
      final y = (random.nextDouble() + _t * speed) % 1 * size.height;
      canvas.drawLine(Offset(x, y), Offset(x - 4, y + 14), paint);
    }
  }

  void _flash(Canvas canvas, Size size) {
    final phase = _t % 7;
    if (phase > 0.15) return;
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.white.withValues(alpha: 0.25),
    );
  }

  void _snow(Canvas canvas, Size size) {
    final random = Random(5);
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.9);
    for (var i = 0; i < 45; i++) {
      final speed = 0.08 + random.nextDouble() * 0.08;
      final y = (random.nextDouble() + _t * speed) % 1 * size.height;
      final x = random.nextDouble() * size.width + sin(_t + i) * 10;
      canvas.drawCircle(Offset(x, y), 2 + random.nextDouble() * 2.5, paint);
    }
  }

  void _fog(Canvas canvas, Size size) {
    for (var i = 0; i < 3; i++) {
      final y = size.height * (0.3 + 0.2 * i);
      final x = (sin(_t * 0.1 + i * 2) * 0.2) * size.width;
      final band = Rect.fromLTWH(x - 40, y, size.width + 80, 50);
      canvas.drawOval(
        band,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
      );
    }
  }

  void _sun(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.85, size.height * 0.1);
    final glow = 60 + 6 * sin(_t * 1.5);
    canvas.drawCircle(
      center,
      glow,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0x66FFD54F), Color(0x00FFD54F)],
        ).createShader(Rect.fromCircle(center: center, radius: glow)),
    );
  }

  @override
  bool shouldRepaint(WeatherPainter old) => old.world != world;
}
