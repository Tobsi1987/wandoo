import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/hunger/domain/belly.dart';
import 'package:wandoo/features/hunger/domain/belly_repository.dart';
import 'package:wandoo/features/hunger/domain/farewell.dart';

/// Speichert Balken und Brief als JSON in den Einstellungen.
class DriftBellyRepository implements BellyRepository {
  DriftBellyRepository(this._db);

  final AppDatabase _db;
  static String _bellyKey(String lineKey) => 'hunger.belly.$lineKey';
  static const _letterKey = 'hunger.farewell';

  @override
  Future<Belly?> load(String lineKey) async =>
      _belly(await _query(_bellyKey(lineKey)).getSingleOrNull());

  @override
  Stream<Belly?> watch(String lineKey) =>
      _query(_bellyKey(lineKey)).watchSingleOrNull().map(_belly);

  @override
  Future<void> save(Belly belly) => _put(_bellyKey(belly.lineKey), {
    'line': belly.lineKey,
    'meters': belly.meters,
    'at': belly.at.toIso8601String(),
  });

  @override
  Future<void> leaveLetter(Farewell? farewell) => farewell == null
      ? (_db.delete(
          _db.preferences,
        )..where((t) => t.key.equals(_letterKey))).go()
      : _put(_letterKey, {
          'species': farewell.speciesId,
          'at': farewell.at.toIso8601String(),
        });

  @override
  Stream<Farewell?> watchLetter() =>
      _query(_letterKey).watchSingleOrNull().map((row) {
        final json = _json(row);
        if (json == null) return null;
        return Farewell(
          speciesId: json['species'] as String,
          at: DateTime.parse(json['at'] as String),
        );
      });

  static Belly? _belly(Preference? row) {
    final json = _json(row);
    if (json == null) return null;
    return Belly(
      lineKey: json['line'] as String,
      meters: (json['meters'] as num).toDouble(),
      at: DateTime.parse(json['at'] as String),
    );
  }

  static Map<String, dynamic>? _json(Preference? row) =>
      row == null ? null : jsonDecode(row.value) as Map<String, dynamic>;

  Future<void> _put(String key, Map<String, Object?> json) => _db
      .into(_db.preferences)
      .insertOnConflictUpdate(Preference(key: key, value: jsonEncode(json)));

  SimpleSelectStatement<$PreferencesTable, Preference> _query(String key) =>
      _db.select(_db.preferences)..where((t) => t.key.equals(key));
}
