import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/domain/furniture.dart';
import 'package:wandoo/features/den/presentation/furniture_labels.dart';
import 'package:wandoo/features/den/presentation/widgets/cave_backdrop.dart';
import 'package:wandoo/features/den/presentation/widgets/furniture_piece.dart';
import 'package:wandoo/features/world/world.dart';

/// Das Zuhause von vorne: Höhle, Möbel auf ihren Plätzen, das Wesen in der
/// Mitte. Ein Tipp auf einen Platz öffnet die Auswahl.
class DenRoomView extends StatelessWidget {
  const DenRoomView({
    required this.room,
    required this.creature,
    required this.world,
    required this.onSpot,
    super.key,
  });

  /// Höhe im Verhältnis zur Breite.
  static const aspect = 1.15;

  final DenRoom room;
  final Creature creature;
  final WorldState world;
  final ValueChanged<Spot> onSpot;

  /// Links, oben und Größe, jeweils als Anteil der Breite.
  static const Map<Spot, (double, double, double)> _boxes = {
    Spot.rug: (0.2, 0.66, 0.6),
    Spot.wall: (0.03, 0.05, 0.36),
    Spot.lamp: (0.67, 0.1, 0.3),
    Spot.bed: (0.0, 0.3, 0.48),
    Spot.plant: (0.66, 0.36, 0.34),
    Spot.toy: (0.66, 0.8, 0.28),
  };

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final w = math.min(box.maxWidth, box.maxHeight / aspect);
      final stage = Rect.fromLTWH(
        (box.maxWidth - w) / 2,
        box.maxHeight - w * aspect,
        w,
        w * aspect,
      );
      return Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: CaveBackdrop(night: world.night, stage: stage),
            ),
          ),
          Positioned.fromRect(
            rect: stage,
            child: Stack(
              children: [
                for (final spot in _grounded) _shadow(spot, w),
                _creatureShadow(w),
                for (final spot in Spot.values.where((s) => s != Spot.toy))
                  _spot(spot, w),
                _creature(w),
                _spot(Spot.toy, w),
              ],
            ),
          ),
        ],
      );
    },
  );

  /// Plätze, die auf dem Boden stehen und einen Schatten werfen.
  static const List<Spot> _grounded = [Spot.bed, Spot.plant, Spot.toy];

  Widget _shadow(Spot spot, double w) {
    if (room.at(spot) == null) return const SizedBox.shrink();
    final (left, top, size) = _boxes[spot]!;
    return _Shadow(
      center: Offset((left + size / 2) * w, (top + size * 0.93) * w),
      width: size * w * 0.8,
    );
  }

  Widget _creatureShadow(double w) =>
      _Shadow(center: Offset(0.5 * w, 0.93 * w), width: 0.32 * w);

  Widget _spot(Spot spot, double w) {
    final (left, top, size) = _boxes[spot]!;
    final f = room.at(spot);
    return Positioned(
      left: left * w,
      top: top * w,
      width: size * w,
      height: size * w,
      child: GestureDetector(
        key: Key('spot-${spot.name}'),
        behavior: HitTestBehavior.opaque,
        onTap: () => onSpot(spot),
        child: f == null
            ? _EmptySpot(label: spotName(spot))
            : FurniturePiece(furniture: f, size: size * w),
      ),
    );
  }

  Widget _creature(double w) => Positioned(
    left: 0.25 * w,
    top: 0.46 * w,
    width: 0.5 * w,
    height: 0.5 * w,
    // Fängt Tipps ab, damit sie nicht beim Teppich dahinter landen.
    child: GestureDetector(
      onTap: () {},
      child: CreatureFigure(
        creature: creature,
        size: 0.5 * w,
        world: world,
        awake: !world.night,
      ),
    ),
  );
}

/// Ein weicher, ovaler Schatten auf dem Boden.
class _Shadow extends StatelessWidget {
  const _Shadow({required this.center, required this.width});

  final Offset center;
  final double width;

  @override
  Widget build(BuildContext context) => Positioned(
    left: center.dx - width / 2,
    top: center.dy - width * 0.12,
    width: width,
    height: width * 0.24,
    child: const DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(200, 50)),
        boxShadow: [
          BoxShadow(color: Color(0x40000000), blurRadius: 12, spreadRadius: -2),
        ],
      ),
    ),
  );
}

/// Ein freier Platz: ein heller Kreis mit Plus.
class _EmptySpot extends StatelessWidget {
  const _EmptySpot({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.55),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0x55FFF3C4), blurRadius: 14),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.add_rounded, color: Color(0xFF8C5A33), size: 22),
          ),
        ),
        const SizedBox(height: 4),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF5B3B26).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
