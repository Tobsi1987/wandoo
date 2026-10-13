import 'package:wandoo/features/creature/domain/rarity.dart';

/// Eine Tierart, die aus dem Ei schlüpfen kann.
class Species {
  const Species({required this.id, required this.name, required this.rarity});

  /// Bleibt für immer gleich, weil Spielstände sie speichern.
  final String id;
  final String name;
  final Rarity rarity;
}
