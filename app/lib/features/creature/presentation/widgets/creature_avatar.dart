import 'package:flutter/material.dart';
import 'package:wandoo/core/format/distance_label.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/species_catalog.dart';
import 'package:wandoo/features/creature/presentation/creature_labels.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_celebration.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_figure.dart';
import 'package:wandoo/features/creature/presentation/widgets/trait_badge.dart';
import 'package:wandoo/features/world/world.dart';

/// Zeigt das Wesen als Figur, dazu Stufe, Futter und Merkmale.
class CreatureAvatar extends StatelessWidget {
  const CreatureAvatar({
    required this.creature,
    this.figureSize = 180,
    this.world,
    this.inScene = false,
    this.walking = false,
    super.key,
  });

  final Creature creature;

  /// Nacht und Jahreszeit für die Figur.
  final WorldState? world;

  /// Kantenlänge der gezeichneten Figur.
  final double figureSize;

  /// Steht schon in der Welt (Startseite): kein eigenes Himmelsfenster.
  final bool inScene;

  /// Während eines Gangs: wach und hüpft vor Freude.
  final bool walking;

  String get _title => creature.hatched
      ? SpeciesCatalog.byId(creature.speciesId).name
      : stageLabel(creature.stage);

  Widget _figure() {
    final figure = CreatureCelebration(
      creature: creature,
      size: figureSize,
      cheer: walking,
      builder: (c) => CreatureFigure(
        creature: c,
        size: figureSize,
        world: world,
        awake: walking,
      ),
    );
    final w = world;
    return w == null || inScene ? figure : SkyBox(world: w, child: figure);
  }

  String get _subtitle {
    final walked =
        '👣 ${distanceLabel(creature.walkedMeters)} zusammen gelaufen';
    if (!creature.hatched) return walked;
    final rarity = SpeciesCatalog.byId(creature.speciesId).rarity;
    return '${stageLabel(creature.stage)} · ${rarityLabel(rarity)}\n$walked';
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(label: 'Dein Wesen: $_title', child: _figure()),
        const SizedBox(height: 8),
        Text(
          _title,
          style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(_subtitle, style: text.bodySmall, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            for (final entry in creature.traitPoints.entries)
              TraitBadge(trait: entry.key, points: entry.value),
          ],
        ),
      ],
    );
  }
}
