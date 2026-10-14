import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/levels/domain/progress.dart';
import 'package:wandoo/features/levels/domain/progress_repository.dart';

/// Speichert die Erfahrung als JSON in den Einstellungen.
class DriftProgressRepository implements ProgressRepository {
  DriftProgressRepository(this._db);

  final AppDatabase _db;
  static String _key(String lineKey) => 'levels.progress.$lineKey';

  @override
  Future<Progress> load(String lineKey) async =>
      _read(lineKey, await _query(lineKey).getSingleOrNull());

  @override
  Stream<Progress> watch(String lineKey) =>
      _query(lineKey).watchSingleOrNull().map((row) => _read(lineKey, row));

  @override
  Future<void> save(Progress progress) => _db
      .into(_db.preferences)
      .insertOnConflictUpdate(
        Preference(
          key: _key(progress.lineKey),
          value: jsonEncode({
            'line': progress.lineKey,
            'xp': progress.xp,
            'news': progress.news,
          }),
        ),
      );

  static Progress _read(String lineKey, Preference? row) {
    if (row == null) return Progress(lineKey: lineKey);
    final json = jsonDecode(row.value) as Map<String, dynamic>;
    return Progress(
      lineKey: lineKey,
      xp: json['xp'] as int,
      news: [for (final n in json['news'] as List<dynamic>) n as String],
    );
  }

  SimpleSelectStatement<$PreferencesTable, Preference> _query(String lineKey) =>
      _db.select(_db.preferences)..where((t) => t.key.equals(_key(lineKey)));
}
