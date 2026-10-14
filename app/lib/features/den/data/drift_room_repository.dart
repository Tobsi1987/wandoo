import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/den/data/room_json.dart';
import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/domain/room_repository.dart';

/// Speichert das Zuhause als JSON in den Einstellungen.
class DriftRoomRepository implements RoomRepository {
  DriftRoomRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static const _key = 'den.room';

  @override
  Future<DenRoom> load() async => _read(await _store.getJson(_key));

  @override
  Stream<DenRoom> watch() => _store.watchJson(_key).map(_read);

  @override
  Future<void> save(DenRoom room) => _store.putJson(_key, roomToJson(room));

  static DenRoom _read(Map<String, dynamic>? json) =>
      json == null ? const DenRoom() : roomFromJson(json);
}
