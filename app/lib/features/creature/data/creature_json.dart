import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/domain/trait.dart';

/// Ein Wesen als JSON, zum Beispiel für die Höhle.
Map<String, Object?> creatureToJson(Creature c) => {
  'food': c.food,
  'traits': {for (final e in c.traitPoints.entries) e.key.name: e.value},
  'fedAt': c.lastFedAt?.toIso8601String(),
  'species': c.speciesId,
  'releasedAt': c.lastReleasedAt?.toIso8601String(),
  'hat': c.hat?.name,
  'neck': c.neck?.name,
  'seen': c.seenSpecies.toList(),
  'lucky': c.luckyEgg,
  'meters': c.walkedMeters,
};

Creature creatureFromJson(Map<String, dynamic> json) {
  final traits = json['traits'] as Map<String, dynamic>;
  return Creature(
    food: json['food'] as int,
    traitPoints: {
      for (final e in traits.entries)
        ?Trait.values.asNameMap()[e.key]: e.value as int,
    },
    lastFedAt: _time(json['fedAt']),
    speciesId: json['species'] as String?,
    lastReleasedAt: _time(json['releasedAt']),
    hat: CreatureHat.values.asNameMap()[json['hat']],
    neck: CreatureNeck.values.asNameMap()[json['neck']],
    seenSpecies: {for (final s in json['seen'] as List<dynamic>) s as String},
    luckyEgg: json['lucky'] as bool,
    walkedMeters: json['meters'] as int,
  );
}

DateTime? _time(Object? value) =>
    value == null ? null : DateTime.parse(value as String);
