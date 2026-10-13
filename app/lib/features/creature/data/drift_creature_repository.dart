import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/creature_repository.dart';
import 'package:wandoo/features/creature/domain/trait.dart';

/// Speichert das Wesen in der lokalen Datenbank.
class DriftCreatureRepository implements CreatureRepository {
  DriftCreatureRepository(this._db);

  final AppDatabase _db;
  static const _rowId = 1;

  @override
  Future<Creature> load() async =>
      _toCreature(await _query().getSingleOrNull());

  @override
  Stream<Creature> watch() => _query().watchSingleOrNull().map(_toCreature);

  SimpleSelectStatement<$CreatureStatesTable, CreatureState> _query() =>
      _db.select(_db.creatureStates)..where((t) => t.id.equals(_rowId));

  static Creature _toCreature(CreatureState? row) {
    if (row == null) return const Creature();
    return Creature(
      food: row.food,
      traitPoints: _decodeTraits(row.traitPoints),
      lastFedAt: row.lastFedAt,
      speciesId: row.speciesId,
      lastReleasedAt: row.lastReleasedAt,
    );
  }

  @override
  Future<void> save(Creature creature) => _db
      .into(_db.creatureStates)
      .insertOnConflictUpdate(
        CreatureStatesCompanion.insert(
          id: const Value(_rowId),
          food: Value(creature.food),
          traitPoints: Value(_encodeTraits(creature.traitPoints)),
          lastFedAt: Value(creature.lastFedAt),
          speciesId: Value(creature.speciesId),
          lastReleasedAt: Value(creature.lastReleasedAt),
        ),
      );

  static String _encodeTraits(Map<Trait, int> traits) =>
      jsonEncode({for (final e in traits.entries) e.key.name: e.value});

  static Map<Trait, int> _decodeTraits(String json) {
    final raw = jsonDecode(json) as Map<String, dynamic>;
    return {
      for (final trait in Trait.values)
        if (raw[trait.name] is int) trait: raw[trait.name] as int,
    };
  }
}
