import 'dart:ui';

import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_palette.dart';

/// Das Ei, gesprenkelt in der Körperfarbe. Kurz vor dem Schlüpfen bekommt
/// es Risse.
void paintEgg(Canvas c, double s, Color body, int food) {
  final center = Offset(s / 2, s * 0.55);
  final egg = Path()
    ..moveTo(center.dx, center.dy - s * 0.32)
    ..cubicTo(
      center.dx + s * 0.27,
      center.dy - s * 0.32,
      center.dx + s * 0.27,
      center.dy + s * 0.31,
      center.dx,
      center.dy + s * 0.31,
    )
    ..cubicTo(
      center.dx - s * 0.27,
      center.dy + s * 0.31,
      center.dx - s * 0.27,
      center.dy - s * 0.32,
      center.dx,
      center.dy - s * 0.32,
    );
  c
    ..drawPath(egg, Paint()..color = const Color(0xFFF7F1E3))
    ..drawPath(
      egg,
      Paint()
        ..color = CreaturePalette.outline(body)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.012,
    );
  final spot = Paint()..color = body;
  const spots = [(-0.08, -0.15, 0.04), (0.09, -0.05, 0.05), (-0.1, 0.1, 0.035)];
  for (final (x, y, r) in spots) {
    c.drawCircle(center + Offset(s * x, s * y), s * r, spot);
  }
  if (food * 2 >= GrowthStage.juvenile.foodNeeded) _cracks(c, s, center, body);
}

void _cracks(Canvas c, double s, Offset center, Color body) {
  final crack = Path()
    ..moveTo(center.dx - s * 0.18, center.dy - s * 0.02)
    ..lineTo(center.dx - s * 0.1, center.dy + s * 0.03)
    ..lineTo(center.dx - s * 0.04, center.dy - s * 0.03)
    ..lineTo(center.dx + s * 0.03, center.dy + s * 0.03)
    ..lineTo(center.dx + s * 0.1, center.dy - s * 0.02);
  c.drawPath(
    crack,
    Paint()
      ..color = CreaturePalette.outline(body)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.01,
  );
}
