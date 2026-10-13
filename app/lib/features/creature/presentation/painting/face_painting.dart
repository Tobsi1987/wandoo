import 'dart:ui';

import 'package:wandoo/features/creature/presentation/painting/body_geometry.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_palette.dart';

/// Augen, Wangen und Mund. Ein träges Wesen schaut verschlafen.
void paintFace(Canvas c, BodyGeometry b, {required bool sluggish}) {
  final eyeY = b.center.dy - b.radiusY * 0.1;
  final dx = b.radiusX * 0.36;
  final eyeR = b.radiusX * 0.12;
  final ink = Paint()..color = CreaturePalette.eye;
  final lid = Paint()
    ..color = CreaturePalette.eye
    ..style = PaintingStyle.stroke
    ..strokeWidth = eyeR * 0.4
    ..strokeCap = StrokeCap.round;
  for (final side in [-1.0, 1.0]) {
    final eye = Offset(b.center.dx + side * dx, eyeY);
    if (sluggish) {
      c.drawLine(eye - Offset(eyeR, 0), eye + Offset(eyeR, 0), lid);
    } else {
      c
        ..drawCircle(eye, eyeR, ink)
        ..drawCircle(
          eye + Offset(-eyeR * 0.35, -eyeR * 0.35),
          eyeR * 0.35,
          Paint()..color = const Color(0xFFFFFFFF),
        );
    }
    c.drawOval(
      Rect.fromCenter(
        center: Offset(eye.dx + side * eyeR * 0.6, eyeY + eyeR * 1.9),
        width: eyeR * 2,
        height: eyeR * 1.1,
      ),
      Paint()..color = CreaturePalette.cheek,
    );
  }
  final mouthY = eyeY + eyeR * 2.2;
  final mouth = Rect.fromCenter(
    center: Offset(b.center.dx, mouthY),
    width: eyeR * 2.2,
    height: eyeR * (sluggish ? 0.6 : 1.6),
  );
  c.drawArc(mouth, 0.2, 2.74, false, lid);
}
