import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/domain/rarity.dart';
import 'package:wandoo/features/creature/domain/trait.dart';

/// Anzeigename einer Entwicklungsstufe.
String stageLabel(GrowthStage stage) => switch (stage) {
  GrowthStage.egg => 'Ei',
  GrowthStage.juvenile => 'Jungtier',
  GrowthStage.adult => 'Ausgewachsen',
};

/// Anzeigename eines Merkmals.
String traitLabel(Trait trait) => switch (trait) {
  Trait.moss => 'Moos',
  Trait.fins => 'Flossen',
  Trait.lanterns => 'Laternen',
  Trait.wheatEars => 'Ähren',
};

/// Anzeigename einer Seltenheit.
String rarityLabel(Rarity rarity) => switch (rarity) {
  Rarity.common => 'Gewöhnlich',
  Rarity.rare => 'Selten',
  Rarity.epic => 'Episch',
  Rarity.legendary => 'Legendär',
};

/// "noch 3 Tage", "noch 5 Stunden" – für die Wegschick-Pause.
String waitLabel(Duration left) {
  if (left.inHours >= 24) {
    final days = (left.inHours / 24).ceil();
    return 'noch $days ${days == 1 ? 'Tag' : 'Tage'}';
  }
  final hours = left.inMinutes <= 60 ? 1 : (left.inMinutes / 60).ceil();
  return 'noch $hours ${hours == 1 ? 'Stunde' : 'Stunden'}';
}
