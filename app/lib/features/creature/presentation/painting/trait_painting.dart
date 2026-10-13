import 'dart:ui';

import 'package:wandoo/features/creature/domain/trait.dart';
import 'package:wandoo/features/creature/presentation/painting/body_geometry.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_palette.dart';

/// Zeichnet die Teile eines Merkmals, die hinter dem Körper liegen.
void paintTraitBehind(Canvas c, BodyGeometry b, Trait trait, int level) {
  switch (trait) {
    case Trait.fins:
      _fins(c, b, level);
    case Trait.lanterns:
      _lanterns(c, b, level);
    case Trait.wheatEars:
      _wheat(c, b, level);
    case Trait.moss:
      break;
  }
}

/// Zeichnet die Teile eines Merkmals, die auf dem Körper liegen.
void paintTraitOnTop(Canvas c, BodyGeometry b, Trait trait, int level) {
  if (trait == Trait.moss) _moss(c, b, level);
}

void _moss(Canvas c, BodyGeometry b, int level) {
  final paint = Paint()..color = CreaturePalette.moss;
  final light = Paint()..color = CreaturePalette.moss.withValues(alpha: 0.6);
  final tufts = 2 + level * 2;
  final r = b.radiusX * 0.13;
  for (var i = 0; i < tufts; i++) {
    final angle = -150 + 120 * i / (tufts - 1);
    final p = b.surface(angle, grow: 0.97);
    c
      ..drawCircle(p, r, paint)
      ..drawCircle(p + Offset(r * 0.7, -r * 0.3), r * 0.75, light);
  }
}

void _fins(Canvas c, BodyGeometry b, int level) {
  final paint = Paint()..color = CreaturePalette.fin.withValues(alpha: 0.85);
  final length = b.radiusX * (0.25 + 0.1 * level);
  for (final side in [-1.0, 1.0]) {
    final base = b.surface(side < 0 ? 180 : 0, grow: 0.85);
    final path = Path()
      ..moveTo(base.dx, base.dy - b.radiusY * 0.3)
      ..quadraticBezierTo(
        base.dx + side * length,
        base.dy - b.radiusY * 0.4,
        base.dx + side * length * 0.9,
        base.dy + b.radiusY * 0.25,
      )
      ..quadraticBezierTo(
        base.dx + side * length * 0.4,
        base.dy + b.radiusY * 0.1,
        base.dx,
        base.dy + b.radiusY * 0.25,
      )
      ..close();
    c.drawPath(path, paint);
  }
  if (level < 3) return;
  final top = b.surface(-90, grow: 0.9);
  final crest = Path()
    ..moveTo(top.dx - b.radiusX * 0.25, top.dy)
    ..quadraticBezierTo(top.dx, top.dy - b.radiusY * 0.6, top.dx + 1, top.dy)
    ..quadraticBezierTo(
      top.dx + b.radiusX * 0.1,
      top.dy - b.radiusY * 0.3,
      top.dx + b.radiusX * 0.25,
      top.dy,
    )
    ..close();
  c.drawPath(crest, paint);
}

void _lanterns(Canvas c, BodyGeometry b, int level) {
  final stem = Paint()
    ..color = CreaturePalette.lanternStem
    ..style = PaintingStyle.stroke
    ..strokeWidth = b.radiusX * 0.05
    ..strokeCap = StrokeCap.round;
  final glow = Paint()
    ..color = CreaturePalette.lanternGlow.withValues(alpha: 0.45)
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, b.radiusX * 0.12);
  final bulb = Paint()..color = CreaturePalette.lanternGlow;
  const angles = [-105.0, -75.0, -90.0];
  for (var i = 0; i < level; i++) {
    final start = b.surface(angles[i], grow: 0.9);
    final dir = b.outward(angles[i]);
    final end = start + dir * b.radiusY * (0.75 + 0.1 * i);
    final control =
        start + dir * b.radiusY * 0.4 + Offset(dir.dx * b.radiusX * 0.3, 0);
    c
      ..drawPath(
        Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy),
        stem,
      )
      ..drawCircle(end, b.radiusX * 0.2, glow)
      ..drawCircle(end, b.radiusX * 0.1, bulb);
  }
}

void _wheat(Canvas c, BodyGeometry b, int level) {
  final stalk = Paint()
    ..color = CreaturePalette.wheat
    ..style = PaintingStyle.stroke
    ..strokeWidth = b.radiusX * 0.04
    ..strokeCap = StrokeCap.round;
  final grain = Paint()..color = CreaturePalette.wheat;
  const angles = [-130.0, -50.0, -150.0, -30.0];
  final count = level + 1;
  for (var i = 0; i < count; i++) {
    final dir = b.outward(angles[i]);
    final start = b.surface(angles[i], grow: 0.9);
    final end = start + dir * b.radiusY * 0.7;
    c.drawLine(start, end, stalk);
    for (var g = 0; g < 4; g++) {
      final p = Offset.lerp(start, end, 0.45 + g * 0.17)!;
      final w = b.radiusX * 0.07;
      c.drawOval(
        Rect.fromCenter(center: p, width: w * 1.4, height: w * 2.2),
        grain,
      );
    }
  }
}
