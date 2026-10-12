import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/domain/trait.dart';

/// Das Wesen des Spielers.
class Creature {
  const Creature({this.food = 0, this.traitPoints = const {}, this.lastFedAt});

  /// Ohne Neues wird das Wesen nach dieser Zeit träge (keine Bestrafung).
  static const sluggishAfter = Duration(days: 3);

  /// Summe aller gefressenen neuen Abschnitte.
  final int food;

  /// Wie stark jedes Merkmal ausgeprägt ist.
  final Map<Trait, int> traitPoints;

  final DateTime? lastFedAt;

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

  bool isSluggish(DateTime now) {
    final fed = lastFedAt;
    return fed != null && now.difference(fed) > sluggishAfter;
  }

  Creature copyWith({
    int? food,
    Map<Trait, int>? traitPoints,
    DateTime? lastFedAt,
  }) {
    return Creature(
      food: food ?? this.food,
      traitPoints: traitPoints ?? this.traitPoints,
      lastFedAt: lastFedAt ?? this.lastFedAt,
    );
  }
}
