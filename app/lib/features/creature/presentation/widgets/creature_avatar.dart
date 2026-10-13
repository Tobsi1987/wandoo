import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/presentation/creature_labels.dart';
import 'package:wandoo/features/creature/presentation/widgets/trait_badge.dart';

/// Platzhalter-Darstellung des Wesens, bis die Grafiken da sind.
class CreatureAvatar extends StatelessWidget {
  const CreatureAvatar({required this.creature, super.key});

  final Creature creature;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(stageLabel(creature.stage), style: text.headlineMedium),
        const SizedBox(height: 8),
        Text('${creature.food} neue Abschnitte gefressen'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            for (final entry in creature.traitPoints.entries)
              TraitBadge(trait: entry.key, points: entry.value),
          ],
        ),
      ],
    );
  }
}
