import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Kleine „z“, die über dem Kopf eines schlafenden Wesens aufsteigen und
/// verblassen, damit man die geschlossenen Augen als Schlaf erkennt.
class SleepZs extends CustomPainter {
  SleepZs(this.time) : super(repaint: time);

  final ValueListenable<double> time;

  /// Sekunden, die ein „z“ vom Kopf bis zum Verschwinden braucht.
  static const _rise = 2.4;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.height;
    for (var i = 0; i < 3; i++) {
      final p = (time.value / _rise + i / 3) % 1;
      final fade = math.sin(math.pi * p);
      final x = size.width * (0.6 + 0.16 * p) + math.sin(p * 6) * unit * 0.02;
      final y = size.height * (0.24 - 0.2 * p);
      final text = TextPainter(
        text: TextSpan(
          text: 'z',
          style: TextStyle(
            fontSize: unit * (0.07 + 0.06 * p),
            fontWeight: FontWeight.w800,
            color: Colors.white.withValues(alpha: 0.95 * fade),
            shadows: [
              Shadow(
                color: const Color(0xFF3A4A8C).withValues(alpha: 0.8 * fade),
                blurRadius: unit * 0.015,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(canvas, Offset(x, y) - Offset(0, text.height / 2));
      text.dispose();
    }
  }

  @override
  bool shouldRepaint(SleepZs old) => old.time != time;
}
