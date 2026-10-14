import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/creature/data/creature_json.dart';
import 'package:wandoo/features/creature/domain/den_repository.dart';

/// Speichert das schlafende Wesen als JSON in den Einstellungen.
class DriftDenRepository implements DenRepository {
  DriftDenRepository(this._db);

  final AppDatabase _db;
  static const _key = 'den.sleeper';

  @override
  Future<Sleeper?> load() async => _read(await _query().getSingleOrNull());

  @override
  Stream<Sleeper?> watch() => _query().watchSingleOrNull().map(_read);

  @override
  Future<void> save(Sleeper sleeper) => _db
      .into(_db.preferences)
      .insertOnConflictUpdate(
        Preference(
          key: _key,
          value: jsonEncode({
            'creature': creatureToJson(sleeper.creature),
            'since': sleeper.since.toIso8601String(),
          }),
        ),
      );

  static Sleeper? _read(Preference? row) {
    if (row == null) return null;
    final json = jsonDecode(row.value) as Map<String, dynamic>;
    return Sleeper(
      creature: creatureFromJson(json['creature'] as Map<String, dynamic>),
      since: DateTime.parse(json['since'] as String),
    );
  }

  SimpleSelectStatement<$PreferencesTable, Preference> _query() =>
      _db.select(_db.preferences)..where((t) => t.key.equals(_key));
}
