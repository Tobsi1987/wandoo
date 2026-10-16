import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/domain/species.dart';
import 'package:wandoo/features/creature/presentation/creature_labels.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_evolution.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_figure.dart';

/// Eine Art im Sammelalbum: Name und Seltenheit, darunter ihre drei
/// Entwicklungsstufen nebeneinander. Noch nicht entdeckt: nur graue Umrisse.
class AlbumRow extends StatelessWidget {
  const AlbumRow({required this.species, required this.seen, super.key});

  final Species species;
  final bool seen;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final name = seen ? species.name : '???';
    return Semantics(
      label: seen ? '$name, entdeckt' : 'Noch nicht entdeckt',
      excludeSemantics: true,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
          child: Column(
            children: [
              Text.rich(
                TextSpan(
                  text: name,
                  style: text.titleMedium,
                  children: [
                    TextSpan(
                      text: '  ${rarityLabel(species.rarity)}',
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  for (var stage = 1; stage <= 3; stage++)
                    Expanded(child: _figure(stage)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _figure(int stage) {
    final model = Creature(
      food: GrowthStage.adult.foodNeeded,
      speciesId: species.id,
    );
    return AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        child: CreatureEvolution(
          creature: model,
          stage: stage,
          child: CreatureFigure(
            creature: model,
            size: 140,
            silhouette: !seen,
            still: true,
          ),
        ),
      ),
    );
  }
}
