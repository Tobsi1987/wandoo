import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wandoo/features/den/presentation/widgets/cave_decor.dart';

/// Die gemütliche Erdhöhle hinter den Möbeln: Gewölbe aus Lehm mit
/// Steinen, Wurzeln an der Decke, Lichterkette, rundes Fenster, ein
/// Regalbrett und ein Holzboden mit Tiefe. Nachts leuchtet es warm.
class CaveBackdrop extends CustomPainter {
  const CaveBackdrop({required this.night, required this.stage});

  final bool night;

  /// Der Bereich, in dem die Möbel stehen; der Boden beginnt in seiner
  /// Mitte. Darüber geht die Wand einfach weiter.
  final Rect stage;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = CaveColors(night: night);
    final floorY = stage.top + stage.height * 0.5;
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = colors.earth);
    final archTop = math
        .min(stage.top - stage.width * 0.05, size.height * 0.06)
        .clamp(0.0, floorY);
    final arch = _arch(size, archTop, floorY);
    canvas
      ..save()
      ..clipPath(arch)
      ..drawRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.wallTop, colors.wall],
          ).createShader(rect),
      );
    stones(canvas, Rect.fromLTRB(0, 0, size.width, floorY), colors);
    _shelf(canvas, colors);
    window(
      canvas,
      Offset(stage.center.dx, stage.top + stage.width * 0.2),
      stage.width * 0.12,
      colors,
    );
    canvas.restore();
    _floor(canvas, size, floorY, colors);
    _baseboard(canvas, size, floorY);
    rim(canvas, arch, colors);
    roots(canvas, size, archTop, colors);
    garland(canvas, size, stage, colors);
    _glow(canvas, size, colors);
  }

  /// Schatten, wo die Wand auf den Boden trifft.
  void _baseboard(Canvas canvas, Size size, double floorY) {
    final base = Rect.fromLTRB(
      0,
      floorY,
      size.width,
      floorY + stage.width * 0.06,
    );
    canvas.drawRect(
      base,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x40000000), Color(0x00000000)],
        ).createShader(base),
    );
  }

  /// Das Gewölbe: oben rund, unten bis zum Boden.
  Path _arch(Size size, double top, double floorY) {
    final w = size.width;
    final r = Radius.elliptical(w * 0.5, (floorY - top) * 0.55);
    return Path()..addRRect(
      RRect.fromLTRBAndCorners(
        w * 0.02,
        top,
        w * 0.98,
        floorY + 4,
        topLeft: r,
        topRight: r,
      ),
    );
  }

  void _shelf(Canvas canvas, CaveColors colors) {
    final w = stage.width;
    final y = stage.top + w * 0.385;
    final board = Rect.fromLTRB(
      stage.left + w * 0.68,
      y,
      stage.left + w * 0.96,
      y + w * 0.025,
    );
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          board.shift(const Offset(0, 4)),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0x33000000),
      )
      ..drawRRect(
        RRect.fromRectAndRadius(board, const Radius.circular(4)),
        Paint()..color = colors.wood,
      );
  }

  /// Holzdielen, die nach hinten zusammenlaufen, mit dunklen Rändern.
  void _floor(Canvas canvas, Size size, double y, CaveColors colors) {
    final floor = Rect.fromLTRB(0, y, size.width, size.height);
    canvas.drawRect(
      floor,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.floorBack, colors.floorFront],
        ).createShader(floor),
    );
    final line = Paint()
      ..color = colors.plank
      ..strokeWidth = 1.5;
    // Fluchtpunkt weit über dem Boden: die Dielen laufen leicht zusammen.
    final vanish = Offset(size.width / 2, y - (size.height - y) * 2.5);
    final t = (y - vanish.dy) / (size.height - vanish.dy);
    Offset back(double x) => Offset(vanish.dx + (x - vanish.dx) * t, y);
    final light = Paint()..color = const Color(0x14FFFFFF);
    for (var i = -7; i <= 7; i++) {
      final x = size.width / 2 + i * size.width * 0.13;
      if (i.isEven) {
        final next = x + size.width * 0.13;
        canvas.drawPath(
          Path()
            ..moveTo(back(x).dx, y)
            ..lineTo(back(next).dx, y)
            ..lineTo(next, size.height)
            ..lineTo(x, size.height)
            ..close(),
          light,
        );
      }
      canvas.drawLine(back(x), Offset(x, size.height), line);
    }
  }

  /// Warmes Licht in der Mitte, dunklere Ecken.
  void _glow(Canvas canvas, Size size, CaveColors colors) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: Alignment(0, stage.center.dy / size.height * 2 - 1),
          radius: 0.9,
          colors: [colors.light, const Color(0x00000000), colors.shade],
          stops: const [0, 0.55, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(CaveBackdrop old) =>
      old.night != night || old.stage != stage;
}
