import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/home_widget/domain/widget_snapshot.dart';

/// Übersetzt das Wesen in die Texte des Widgets.
WidgetSnapshot widgetSnapshotFor(Creature creature, DateTime now) {
  final trait = creature.dominantTrait;
  final paths = creature.food == 1 ? 'neuer Weg' : 'neue Wege';
  return WidgetSnapshot(
    face: switch (creature.stage) {
      GrowthStage.egg => '🥚',
      GrowthStage.juvenile => '🐣',
      GrowthStage.adult => '🐲',
    },
    stage: stageLabel(creature.stage),
    detail: trait == null
        ? '${creature.food} $paths'
        : '${creature.food} $paths · viel ${traitLabel(trait)}',
    mood: creature.isSluggish(now)
        ? 'döst und wartet auf Neues'
        : creature.lastFedAt == null
        ? 'wartet auf den ersten Gang'
        : 'ist satt und munter',
  );
}
