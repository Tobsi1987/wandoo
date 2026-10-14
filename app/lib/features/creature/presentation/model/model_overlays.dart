import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Weicher Schatten auf dem Boden unter dem 3D-Modell, wie beim Shader.
///
/// Die Füße stehen bei der Kamera von `CreatureModel` auf rund 82 % der
/// Höhe.
class ModelShadow extends CustomPainter {
  const ModelShadow();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.82);
    final radius = size.width * 0.28;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.black.withValues(alpha: 0.3),
          Colors.black.withValues(alpha: 0.14),
          Colors.transparent,
        ],
        stops: const [0, 0.55, 1],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    // Ein flach gedrückter Kreis ergibt die Ellipse am Boden.
    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..scale(1, 0.22)
      ..translate(-center.dx, -center.dy)
      ..drawCircle(center, radius, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(ModelShadow old) => false;
}

/// Glühwürmchen, die nachts um das schlafende Wesen schweben. Gleiche
/// Bahnen und Farbe wie `fireflies()` in `shaders/creature.frag`.
class Fireflies extends CustomPainter {
  Fireflies(this.time) : super(repaint: time);

  final ValueListenable<double> time;

  static const _glow = Color(0xFFFFD959);

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value;
    final unit = size.height;
    for (var i = 0; i < 6; i++) {
      final x = math.sin(t * 0.5 + i * 1.7) * 0.42;
      final y = 0.05 + math.cos(t * 0.37 + i * 2.3) * 0.3;
      final pulse = 0.55 + 0.45 * math.sin(t * 2.5 + i * 1.3);
      final c = Offset(size.width / 2 + x * unit, size.height / 2 - y * unit);
      final halo = unit * 0.07;
      canvas
        ..drawCircle(
          c,
          halo,
          Paint()
            ..shader = RadialGradient(
              colors: [
                _glow.withValues(alpha: 0.35 * pulse),
                _glow.withValues(alpha: 0),
              ],
            ).createShader(Rect.fromCircle(center: c, radius: halo)),
        )
        ..drawCircle(
          c,
          unit * 0.012,
          Paint()..color = _glow.withValues(alpha: pulse),
        );
    }
  }

  @override
  bool shouldRepaint(Fireflies old) => false;
}
