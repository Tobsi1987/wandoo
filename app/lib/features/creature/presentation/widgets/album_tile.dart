import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/domain/species.dart';
import 'package:wandoo/features/creature/presentation/creature_labels.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_figure.dart';

/// Eine Art im Sammelalbum: entdeckt in Farbe, sonst nur als Umriss.
class AlbumTile extends StatelessWidget {
  const AlbumTile({required this.species, required this.seen, super.key});

  final Species species;
  final bool seen;

  Creature get _model =>
      Creature(food: GrowthStage.adult.foodNeeded, speciesId: species.id);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final name = seen ? species.name : '???';
    return Semantics(
      label: seen ? '$name, entdeckt' : 'Noch nicht entdeckt',
      excludeSemantics: true,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: FittedBox(
                  child: CreatureFigure(
                    creature: _model,
                    size: 140,
                    silhouette: !seen,
                    still: true,
                  ),
                ),
              ),
              Text(name, style: text.titleMedium, textAlign: TextAlign.center),
              Text(rarityLabel(species.rarity), style: text.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
