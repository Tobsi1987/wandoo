import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';

/// Kleine Einträge in der Tabelle `preferences`: Text oder JSON unter
/// einem Schlüssel. Die Repositories der Features bauen darauf auf, statt
/// jedes Mal selbst Abfragen zu schreiben.
class PreferenceStore {
  const PreferenceStore(this._db);

  final AppDatabase _db;

  Future<String?> get(String key) async =>
      (await _query(key).getSingleOrNull())?.value;

  Stream<String?> watch(String key) =>
      _query(key).watchSingleOrNull().map((row) => row?.value);

  Future<void> put(String key, String value) => _db
      .into(_db.preferences)
      .insertOnConflictUpdate(Preference(key: key, value: value));

  Future<void> remove(String key) =>
      (_db.delete(_db.preferences)..where((t) => t.key.equals(key))).go();

  Future<Map<String, dynamic>?> getJson(String key) async =>
      _decode(await get(key));

  Stream<Map<String, dynamic>?> watchJson(String key) =>
      watch(key).map(_decode);

  Future<void> putJson(String key, Map<String, Object?> json) =>
      put(key, jsonEncode(json));

  static Map<String, dynamic>? _decode(String? text) =>
      text == null ? null : jsonDecode(text) as Map<String, dynamic>;

  SimpleSelectStatement<$PreferencesTable, Preference> _query(String key) =>
      _db.select(_db.preferences)..where((t) => t.key.equals(key));
}
