import 'package:wandoo/features/creature/creature.dart';

/// Begleittext zum Teilen-Bild, z. B.
/// "Mein Wandoo-Wesen ist ein Jungtier mit viel Moos. 42 neue Wege entdeckt."
String shareCaption(Creature creature) {
  final stage = stageLabel(creature.stage);
  final trait = creature.dominantTrait;
  final look = trait == null ? '' : ' mit viel ${traitLabel(trait)}';
  final article = creature.stage == GrowthStage.egg ? 'noch ein' : 'jetzt';
  return 'Mein Wandoo-Wesen ist $article $stage$look. '
      '${creature.food} neue Wege entdeckt.';
}
