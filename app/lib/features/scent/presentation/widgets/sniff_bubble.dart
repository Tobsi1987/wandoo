import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/scent/application/scent_providers.dart';
import 'package:wandoo/features/scent/domain/scent.dart';
import 'package:wandoo/features/scent/domain/scent_hint.dart';
import 'package:wandoo/features/scent/presentation/scent_labels.dart';
import 'package:wandoo/features/tracking/tracking.dart';

/// Die Spürnase: Vor dem Gang sagt sie, dass das Wesen etwas riecht,
/// unterwegs zeigt ein Pfeil die Richtung und heiß oder kalt die Nähe.
class SniffBubble extends ConsumerWidget {
  const SniffBubble({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creature = ref.watch(creatureProvider).value;
    final scent = ref.watch(scentProvider).value;
    if (creature == null || !creature.hatched || scent == null) {
      return const SizedBox.shrink();
    }
    final name = SpeciesCatalog.byId(creature.speciesId).name;
    final session = ref.watch(trackingControllerProvider);
    final here = session is WalkRecording ? session.position : null;
    final from = session is WalkRecording ? session.cameFrom : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: here == null
              ? Text('👃 $name riecht etwas! Geh los und folge der Nase.')
              : _Hint(scent: scent, here: here, cameFrom: from, name: name),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({
    required this.scent,
    required this.here,
    required this.cameFrom,
    required this.name,
  });

  final Scent scent;
  final GeoPoint here;
  final GeoPoint? cameFrom;
  final String name;

  @override
  Widget build(BuildContext context) {
    final hint = ScentHint.toward(scent.target, here, cameFrom: cameFrom);
    final turn = hint.turn;
    final label = heatLabel(hint.heat, name);
    return Semantics(
      label: turn == null ? label : '$label, ${_side(turn)}',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (turn != null) ...[
            AnimatedRotation(
              turns: turn / (2 * math.pi),
              duration: const Duration(milliseconds: 600),
              child: const Icon(Icons.navigation, size: 28),
            ),
            const SizedBox(width: 10),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              if (hint.heat != Heat.found)
                Text(
                  roughMeters(hint.meters),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Richtung in Worten, für Bildschirmleser.
  static String _side(double turn) {
    final deg = turn * 180 / math.pi;
    if (deg.abs() < 30) return 'geradeaus';
    if (deg.abs() > 150) return 'hinter dir';
    return deg > 0 ? 'rechts' : 'links';
  }
}
