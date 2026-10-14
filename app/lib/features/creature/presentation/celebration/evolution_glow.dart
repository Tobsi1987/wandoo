import 'package:flutter/material.dart';

/// Das helle Leuchten, in dem sich das Wesen entwickelt. Bei [glow] = 1
/// verdeckt es die Figur fast ganz, damit der Wechsel der Gestalt nicht
/// auffällt.
class EvolutionGlow extends CustomPainter {
  EvolutionGlow(this.glow);

  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    if (glow <= 0) return;
    final center = Offset(size.width * 0.5, size.height * 0.55);
    final radius = size.width * (0.35 + 0.3 * glow);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.95 * glow),
          const Color(0xFFFFF3C4).withValues(alpha: 0.8 * glow),
          const Color(0xFFFFD86B).withValues(alpha: 0.3 * glow),
          Colors.transparent,
        ],
        stops: const [0, 0.45, 0.75, 1],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(EvolutionGlow old) => old.glow != glow;
}
