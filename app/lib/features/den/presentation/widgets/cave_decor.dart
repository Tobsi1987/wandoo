import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Die Farben der Höhle bei Tag und bei Nacht.
class CaveColors {
  const CaveColors({required this.night});

  final bool night;

  Color _c(int day, int nightColor) => Color(night ? nightColor : day);

  Color get earth => _c(0xFF6B4630, 0xFF2A1E22);
  Color get wallTop => _c(0xFFE2B98A, 0xFF4B3A4E);
  Color get wall => _c(0xFFF0CFA0, 0xFF5A4656);
  Color get stone => _c(0x22704A2C, 0x33000000);
  Color get stoneLight => _c(0x33FFFFFF, 0x14FFFFFF);
  Color get wood => _c(0xFF9C6B3F, 0xFF6A4C3A);
  Color get floorBack => _c(0xFFB67E4B, 0xFF4A3840);
  Color get floorFront => _c(0xFFD9A46C, 0xFF62505A);
  Color get plank => _c(0x30000000, 0x40000000);
  Color get root => _c(0xFF7A5134, 0xFF3B2A28);
  Color get leaf => _c(0xFF79B04A, 0xFF4E7A3A);
  Color get sky => _c(0xFFA6DAF7, 0xFF1C2550);
  Color get light => _c(0x33FFF3D6, 0x40FFC870);
  Color get shade => _c(0x40301A0C, 0x80100810);
}

/// Runde Steine in der Lehmwand, immer an denselben Stellen.
void stones(Canvas canvas, Rect wall, CaveColors colors) {
  final random = math.Random(7);
  final dark = Paint()..color = colors.stone;
  final light = Paint()..color = colors.stoneLight;
  for (var i = 0; i < 26; i++) {
    final c = Offset(
      wall.left + random.nextDouble() * wall.width,
      wall.top + (0.15 + 0.85 * random.nextDouble()) * wall.height,
    );
    final r = wall.width * (0.015 + random.nextDouble() * 0.03);
    final oval = Rect.fromCenter(center: c, width: r * 2.4, height: r * 1.6);
    canvas
      ..drawOval(oval, dark)
      ..drawOval(oval.translate(-r * 0.25, -r * 0.25).deflate(r * 0.35), light);
  }
}

/// Rundes Fenster mit Holzrahmen, Kreuz und Himmel (Wolken oder Mond).
void window(Canvas canvas, Offset center, double r, CaveColors colors) {
  canvas
    ..drawCircle(
      center + Offset(0, r * 0.12),
      r * 1.2,
      Paint()..color = const Color(0x33000000),
    )
    ..drawCircle(center, r * 1.18, Paint()..color = colors.wood)
    ..drawCircle(center, r, Paint()..color = colors.sky)
    ..save()
    ..clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: r)));
  final white = Paint()
    ..color = colors.night ? const Color(0xFFFFF1B8) : Colors.white;
  if (colors.night) {
    canvas
      ..drawCircle(center + Offset(r * 0.3, -r * 0.3), r * 0.32, white)
      ..drawCircle(
        center + Offset(r * 0.45, -r * 0.4),
        r * 0.27,
        Paint()..color = colors.sky,
      );
    for (final s in const [
      Offset(-0.5, -0.2),
      Offset(-0.2, 0.5),
      Offset(0.5, 0.4),
    ]) {
      canvas.drawCircle(center + s * r, r * 0.05, white);
    }
  } else {
    for (final (dx, dy, s) in [
      (-0.35, 0.3, 0.32),
      (0.0, 0.25, 0.4),
      (0.35, 0.32, 0.3),
    ]) {
      canvas.drawCircle(center + Offset(dx * r, dy * r), r * s, white);
    }
  }
  final bar = Paint()
    ..color = colors.wood
    ..strokeWidth = r * 0.1;
  canvas
    ..drawLine(center - Offset(r, 0), center + Offset(r, 0), bar)
    ..drawLine(center - Offset(0, r), center + Offset(0, r), bar)
    ..restore();
}

/// Ein dunkler, weicher Rand um das Gewölbe.
void rim(Canvas canvas, Path arch, CaveColors colors) {
  canvas.drawPath(
    arch,
    Paint()
      ..color = colors.earth
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
  );
}

/// Wurzeln, die oben aus der Decke hängen, mit kleinen Blättern.
void roots(Canvas canvas, Size size, double y, CaveColors colors) {
  final w = size.width;
  final stroke = Paint()
    ..color = colors.root
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  final leaf = Paint()..color = colors.leaf;
  for (final (x, length, bend) in [
    (0.3, 0.12, 0.04),
    (0.4, 0.2, -0.03),
    (0.62, 0.15, -0.05),
    (0.71, 0.09, 0.02),
  ]) {
    final top = Offset(w * x, y);
    final end = Offset(w * (x + bend), y + w * length);
    stroke.strokeWidth = w * 0.012;
    canvas.drawPath(
      Path()
        ..moveTo(top.dx, top.dy)
        ..quadraticBezierTo(w * (x - bend), y + w * length / 2, end.dx, end.dy),
      stroke,
    );
    for (final side in [-1.0, 1.0]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: end + Offset(side * w * 0.018, -w * 0.01),
          width: w * 0.035,
          height: w * 0.02,
        ),
        leaf,
      );
    }
  }
}

/// Eine Lichterkette quer über die Wand; nachts leuchten die Birnchen.
void garland(Canvas canvas, Size size, Rect stage, CaveColors colors) {
  final w = size.width;
  final y = stage.top + stage.width * 0.02;
  final sag = stage.width * 0.1;
  Offset at(double t) =>
      Offset(w * (0.06 + 0.88 * t), y + sag * 4 * t * (1 - t));
  final wire = Path()..moveTo(at(0).dx, at(0).dy);
  for (var i = 1; i <= 20; i++) {
    wire.lineTo(at(i / 20).dx, at(i / 20).dy);
  }
  canvas.drawPath(
    wire,
    Paint()
      ..color = colors.root
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5,
  );
  const bulbs = [0xFFFFD45C, 0xFFFF8FA3, 0xFF8FD3FF, 0xFFA8E07A];
  for (var i = 1; i < 12; i++) {
    final c = at(i / 12) + Offset(0, stage.width * 0.018);
    final color = Color(bulbs[i % bulbs.length]);
    if (colors.night) {
      canvas.drawCircle(
        c,
        stage.width * 0.035,
        Paint()
          ..color = color.withValues(alpha: 0.45)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }
    canvas.drawCircle(c, stage.width * 0.013, Paint()..color = color);
  }
}
