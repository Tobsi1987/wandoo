import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/treasure/domain/accessory.dart';
import 'package:wandoo/features/treasure/domain/find.dart';
import 'package:wandoo/features/treasure/domain/treasure_chest.dart';
import 'package:wandoo/features/treasure/domain/treasure_repository.dart';

/// Speichert die Schatzkiste in der lokalen Datenbank.
class DriftTreasureRepository implements TreasureRepository {
  DriftTreasureRepository(this._db);

  final AppDatabase _db;
  static const _rowId = 1;
  static const _plan = 'plan:';

  @override
  Future<TreasureChest> load() async =>
      _toChest(await _query().getSingleOrNull());

  @override
  Stream<TreasureChest> watch() => _query().watchSingleOrNull().map(_toChest);

  @override
  Future<void> save(TreasureChest chest) => _db
      .into(_db.treasureStates)
      .insertOnConflictUpdate(
        TreasureStatesCompanion.insert(
          id: const Value(_rowId),
          finds: Value(jsonEncode(_findsJson(chest))),
          // Baupläne stehen mit "plan:" davor in derselben Liste.
          owned: Value(
            jsonEncode([
              for (final a in chest.owned) a.name,
              for (final a in chest.plans) '$_plan${a.name}',
            ]),
          ),
        ),
      );

  SimpleSelectStatement<$TreasureStatesTable, TreasureState> _query() =>
      _db.select(_db.treasureStates)..where((t) => t.id.equals(_rowId));

  static TreasureChest _toChest(TreasureState? row) {
    if (row == null) return const TreasureChest();
    final finds = jsonDecode(row.finds) as Map<String, dynamic>;
    final owned = jsonDecode(row.owned) as List<dynamic>;
    final accessories = Accessory.values.asNameMap();
    return TreasureChest(
      finds: {
        for (final f in Find.values)
          if (finds[f.name] is int) f: finds[f.name] as int,
      },
      owned: {for (final name in owned) ?accessories[name]},
      plans: {
        for (final name in owned)
          if (name is String && name.startsWith(_plan))
            ?accessories[name.substring(_plan.length)],
      },
    );
  }

  static Map<String, int> _findsJson(TreasureChest chest) => {
    for (final e in chest.finds.entries) e.key.name: e.value,
  };
}
