import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/den/data/room_json.dart';
import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/domain/room_repository.dart';

/// Speichert das Zuhause als JSON in den Einstellungen.
class DriftRoomRepository implements RoomRepository {
  DriftRoomRepository(this._db);

  final AppDatabase _db;
  static const _key = 'den.room';

  @override
  Future<DenRoom> load() async => _read(await _query().getSingleOrNull());

  @override
  Stream<DenRoom> watch() => _query().watchSingleOrNull().map(_read);

  @override
  Future<void> save(DenRoom room) => _db
      .into(_db.preferences)
      .insertOnConflictUpdate(
        Preference(key: _key, value: jsonEncode(roomToJson(room))),
      );

  static DenRoom _read(Preference? row) => row == null
      ? const DenRoom()
      : roomFromJson(jsonDecode(row.value) as Map<String, dynamic>);

  SimpleSelectStatement<$PreferencesTable, Preference> _query() =>
      _db.select(_db.preferences)..where((t) => t.key.equals(_key));
}
