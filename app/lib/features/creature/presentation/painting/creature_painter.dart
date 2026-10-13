import 'package:flutter/rendering.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/presentation/painting/body_geometry.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_palette.dart';
import 'package:wandoo/features/creature/presentation/painting/egg_painting.dart';
import 'package:wandoo/features/creature/presentation/painting/face_painting.dart';
import 'package:wandoo/features/creature/presentation/painting/trait_painting.dart';

/// Zeichnet das Wesen: Ei, Jungtier oder ausgewachsen, mit seinen Merkmalen.
class CreaturePainter extends CustomPainter {
  const CreaturePainter({required this.creature, required this.sluggish});

  final Creature creature;
  final bool sluggish;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    canvas
      ..save()
      ..translate((size.width - s) / 2, (size.height - s) / 2);
    _shadow(canvas, s);
    final body = CreaturePalette.body(creature.dominantTrait);
    if (creature.stage == GrowthStage.egg) {
      paintEgg(canvas, s, body, creature.food);
    } else {
      _creature(canvas, _geometry(s), body);
    }
    canvas.restore();
  }

  BodyGeometry _geometry(double s) {
    final adult = creature.stage == GrowthStage.adult;
    final r = s * (adult ? 0.3 : 0.24);
    return BodyGeometry(
      center: Offset(s / 2, s * 0.86 - r),
      radiusX: r * (adult ? 1.08 : 1),
      radiusY: r * (adult ? 0.95 : 0.92),
    );
  }

  void _creature(Canvas c, BodyGeometry b, Color body) {
    final traits = creature.traitPoints.entries
        .map((e) => (trait: e.key, level: traitLevel(e.value)))
        .where((t) => t.level > 0)
        .toList();
    for (final t in traits) {
      paintTraitBehind(c, b, t.trait, t.level);
    }
    if (creature.stage == GrowthStage.adult) _feet(c, b, body);
    c
      ..drawOval(b.rect, Paint()..color = body)
      ..drawOval(
        b.rect,
        Paint()
          ..color = CreaturePalette.outline(body)
          ..style = PaintingStyle.stroke
          ..strokeWidth = b.radiusX * 0.04,
      );
    _belly(c, b);
    for (final t in traits) {
      paintTraitOnTop(c, b, t.trait, t.level);
    }
    paintFace(c, b, sluggish: sluggish);
  }

  void _belly(Canvas c, BodyGeometry b) {
    final rect = Rect.fromCenter(
      center: b.center + Offset(0, b.radiusY * 0.35),
      width: b.radiusX * 1.1,
      height: b.radiusY * 0.9,
    );
    c.drawOval(rect, Paint()..color = const Color(0x40FFFFFF));
  }

  void _feet(Canvas c, BodyGeometry b, Color body) {
    final paint = Paint()..color = CreaturePalette.outline(body);
    for (final side in [-1.0, 1.0]) {
      final foot = b.surface(90 + side * 35, grow: 0.95);
      c.drawOval(
        Rect.fromCenter(
          center: foot,
          width: b.radiusX * 0.4,
          height: b.radiusY * 0.22,
        ),
        paint,
      );
    }
  }

  void _shadow(Canvas c, double s) {
    c.drawOval(
      Rect.fromCenter(
        center: Offset(s / 2, s * 0.88),
        width: s * 0.5,
        height: s * 0.07,
      ),
      Paint()..color = const Color(0x22000000),
    );
  }

  @override
  bool shouldRepaint(CreaturePainter old) =>
      old.creature != creature || old.sluggish != sluggish;
}
