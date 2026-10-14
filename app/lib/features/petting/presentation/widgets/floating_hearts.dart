import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wandoo/features/petting/presentation/widgets/heart_path.dart';

/// Herzchen, die vom Wesen aufsteigen und verblassen.
class FloatingHearts extends StatelessWidget {
  const FloatingHearts({required this.progress, this.count = 6, super.key});

  /// 0 bis 1 über die ganze Dauer.
  final double progress;
  final int count;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _HeartsPainter(progress, count));
}

class _HeartsPainter extends CustomPainter {
  _HeartsPainter(this.t, this.count);

  final double t;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(count);
    for (var i = 0; i < count; i++) {
      final delay = i / count * 0.4;
      final local = ((t - delay) / 0.6).clamp(0.0, 1.0);
      if (local <= 0 || local >= 1) continue;
      final x = size.width * (0.3 + 0.4 * random.nextDouble());
      final drift = math.sin(local * math.pi * 2 + i) * size.width * 0.04;
      final y = size.height * (0.45 - 0.45 * local);
      final heart = heartPath(
        Offset(x + drift, y),
        size.width * (0.06 + 0.03 * random.nextDouble()),
      );
      canvas.drawPath(
        heart,
        Paint()..color = heartColor.withValues(alpha: 1 - local * local),
      );
    }
  }

  @override
  bool shouldRepaint(_HeartsPainter old) => old.t != t || old.count != count;
}
