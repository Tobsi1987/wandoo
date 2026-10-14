import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/star_catch/domain/star_catch_repository.dart';

/// Speichert den letzten gespielten Gang in den Einstellungen.
class DriftStarCatchRepository implements StarCatchRepository {
  DriftStarCatchRepository(this._db);

  final AppDatabase _db;
  static const _key = 'star_catch.walk';

  @override
  Future<String?> lastWalk() async => (await _query().getSingleOrNull())?.value;

  @override
  Stream<String?> watchLastWalk() =>
      _query().watchSingleOrNull().map((row) => row?.value);

  @override
  Future<void> playedAfter(String walkId) => _db
      .into(_db.preferences)
      .insertOnConflictUpdate(Preference(key: _key, value: walkId));

  SimpleSelectStatement<$PreferencesTable, Preference> _query() =>
      _db.select(_db.preferences)..where((t) => t.key.equals(_key));
}
