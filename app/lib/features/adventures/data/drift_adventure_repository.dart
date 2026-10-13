import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/adventures/data/quest_json.dart';
import 'package:wandoo/features/adventures/domain/adventure_repository.dart';
import 'package:wandoo/features/adventures/domain/weekly_adventure.dart';

/// Speichert die Abenteuer der Woche in der lokalen Datenbank.
class DriftAdventureRepository implements AdventureRepository {
  DriftAdventureRepository(this._db);

  final AppDatabase _db;
  static const _rowId = 1;

  @override
  Future<WeeklyAdventure?> load() async =>
      _toAdventure(await _query().getSingleOrNull());

  @override
  Stream<WeeklyAdventure?> watch() =>
      _query().watchSingleOrNull().map(_toAdventure);

  @override
  Future<void> save(WeeklyAdventure adventure) => _db
      .into(_db.adventureStates)
      .insertOnConflictUpdate(
        AdventureStatesCompanion.insert(
          id: const Value(_rowId),
          weekStart: adventure.weekStart,
          quests: jsonEncode(adventure.quests.map(QuestJson.encode).toList()),
          bonusClaimed: Value(adventure.bonusClaimed),
        ),
      );

  SimpleSelectStatement<$AdventureStatesTable, AdventureState> _query() =>
      _db.select(_db.adventureStates)..where((t) => t.id.equals(_rowId));

  static WeeklyAdventure? _toAdventure(AdventureState? row) {
    if (row == null) return null;
    final raw = jsonDecode(row.quests);
    final quests = [
      if (raw is List)
        for (final q in raw) ?QuestJson.decode(q),
    ];
    return WeeklyAdventure(
      weekStart: row.weekStart,
      quests: quests,
      bonusClaimed: row.bonusClaimed,
    );
  }
}
