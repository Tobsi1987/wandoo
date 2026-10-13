import 'package:wandoo/features/creature/domain/growth_stage.dart';
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
