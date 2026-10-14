import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/star_catch/domain/star_catch_repository.dart';

/// Speichert den letzten gespielten Gang in den Einstellungen.
class DriftStarCatchRepository implements StarCatchRepository {
  DriftStarCatchRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static const _key = 'star_catch.walk';

  @override
  Future<String?> lastWalk() => _store.get(_key);

  @override
  Stream<String?> watchLastWalk() => _store.watch(_key);

  @override
  Future<void> playedAfter(String walkId) => _store.put(_key, walkId);
}
