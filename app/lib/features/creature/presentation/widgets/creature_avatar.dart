import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/species_catalog.dart';
import 'package:wandoo/features/creature/presentation/creature_labels.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_figure.dart';
import 'package:wandoo/features/creature/presentation/widgets/trait_badge.dart';

/// Zeigt das Wesen als Figur, dazu Stufe, Futter und Merkmale.
class CreatureAvatar extends StatelessWidget {
  const CreatureAvatar({
    required this.creature,
    this.figureSize = 180,
    super.key,
  });

  final Creature creature;

  /// Kantenlänge der gezeichneten Figur.
  final double figureSize;

  String get _title => creature.hatched
      ? SpeciesCatalog.byId(creature.speciesId).name
      : stageLabel(creature.stage);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: 'Dein Wesen: $_title',
          child: CreatureFigure(creature: creature, size: figureSize),
        ),
        const SizedBox(height: 8),
        Text(_title, style: text.headlineMedium),
        if (creature.hatched)
          Text(
            '${stageLabel(creature.stage)} · '
            '${rarityLabel(SpeciesCatalog.byId(creature.speciesId).rarity)}',
          ),
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
