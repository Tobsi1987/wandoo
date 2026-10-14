import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/achievements/data/stats_json.dart';
import 'package:wandoo/features/achievements/domain/lifetime_stats.dart';
import 'package:wandoo/features/achievements/domain/stats_repository.dart';

/// Speichert die Zahlen als JSON in den Einstellungen.
class DriftStatsRepository implements StatsRepository {
  DriftStatsRepository(this._db);

  final AppDatabase _db;
  static const _key = 'achievements.stats';

  @override
  Future<LifetimeStats> load() async => _read(await _query().getSingleOrNull());

  @override
  Stream<LifetimeStats> watch() => _query().watchSingleOrNull().map(_read);

  @override
  Future<void> save(LifetimeStats stats) => _db
      .into(_db.preferences)
      .insertOnConflictUpdate(
        Preference(key: _key, value: jsonEncode(statsToJson(stats))),
      );

  static LifetimeStats _read(Preference? row) => row == null
      ? const LifetimeStats()
      : statsFromJson(jsonDecode(row.value) as Map<String, dynamic>);

  SimpleSelectStatement<$PreferencesTable, Preference> _query() =>
      _db.select(_db.preferences)..where((t) => t.key.equals(_key));
}
