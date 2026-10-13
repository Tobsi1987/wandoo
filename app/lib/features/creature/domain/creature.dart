import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/domain/trait.dart';

/// Das Wesen des Spielers.
class Creature {
  const Creature({
    this.food = 0,
    this.traitPoints = const {},
    this.lastFedAt,
    this.speciesId,
    this.lastReleasedAt,
    this.hat,
    this.neck,
    this.seenSpecies = const {},
    this.luckyEgg = false,
  });

  /// Ohne Neues wird das Wesen nach dieser Zeit träge (keine Bestrafung).
  static const sluggishAfter = Duration(days: 3);

  /// Summe aller gefressenen neuen Abschnitte.
  final int food;

  /// Wie stark jedes Merkmal ausgeprägt ist.
  final Map<Trait, int> traitPoints;

  final DateTime? lastFedAt;

  /// Beim Schlüpfen zufällig gezogene Tierart (`Species.id`), danach fest.
  final String? speciesId;

  /// Wann zuletzt ein Wesen weggeschickt wurde; bleibt beim neuen Ei.
  final DateTime? lastReleasedAt;

  final CreatureHat? hat;
  final CreatureNeck? neck;

  /// Alle Arten, die je geschlüpft sind, fürs Sammelalbum. Bleibt beim
  /// Wegschicken erhalten.
  final Set<String> seenSpecies;

  /// Belohnung aus Abenteuern: Das nächste Ei schlüpft mindestens selten.
  final bool luckyEgg;

  bool get hatched => stage != GrowthStage.egg;

  /// Alle Arten fürs Album, auch die aktuelle aus Spielständen von vor
  /// dem Album.
  Set<String> get discoveredSpecies => {...seenSpecies, ?speciesId};

  GrowthStage get stage => GrowthStage.forFood(food);

  /// Das ausgeprägteste Merkmal, oder null, solange nichts gefressen wurde.
  Trait? get dominantTrait {
    Trait? best;
    var bestPoints = 0;
    traitPoints.forEach((trait, points) {
      if (points > bestPoints) {
        best = trait;
        bestPoints = points;
      }
    });
    return best;
  }

  /// Das zweitstärkste Merkmal; es färbt Muster ins Fell.
  Trait? get accentTrait {
    final ranked = traitPoints.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return ranked.length > 1 ? ranked[1].key : null;
  }

  bool isSluggish(DateTime now) {
    final fed = lastFedAt;
    return fed != null && now.difference(fed) > sluggishAfter;
  }

  Creature copyWith({
    int? food,
    Map<Trait, int>? traitPoints,
    DateTime? lastFedAt,
    String? speciesId,
    Set<String>? seenSpecies,
    bool? luckyEgg,
  }) {
    return Creature(
      food: food ?? this.food,
      traitPoints: traitPoints ?? this.traitPoints,
      lastFedAt: lastFedAt ?? this.lastFedAt,
      speciesId: speciesId ?? this.speciesId,
      lastReleasedAt: lastReleasedAt,
      hat: hat,
      neck: neck,
      seenSpecies: seenSpecies ?? this.seenSpecies,
      luckyEgg: luckyEgg ?? this.luckyEgg,
    );
  }

  /// Zieht dem Wesen Deko an oder aus (null = nichts).
  Creature wearing({required CreatureHat? hat, required CreatureNeck? neck}) =>
      Creature(
        food: food,
        traitPoints: traitPoints,
        lastFedAt: lastFedAt,
        speciesId: speciesId,
        lastReleasedAt: lastReleasedAt,
        hat: hat,
        neck: neck,
        seenSpecies: seenSpecies,
        luckyEgg: luckyEgg,
      );
}
