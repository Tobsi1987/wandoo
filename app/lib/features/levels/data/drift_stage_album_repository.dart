import 'dart:math';

import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/levels/domain/stage_album_repository.dart';

/// Speichert die erreichten Stufen als JSON in den Einstellungen.
class DriftStageAlbumRepository implements StageAlbumRepository {
  DriftStageAlbumRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static const _key = 'levels.album';

  @override
  Stream<Map<String, int>> watch() => _store.watchJson(_key).map(_read);

  @override
  Future<void> reach(String speciesId, int stage) async {
    final all = _read(await _store.getJson(_key));
    final best = max(all[speciesId] ?? 1, stage);
    if (best == all[speciesId]) return;
    await _store.putJson(_key, {...all, speciesId: best});
  }

  static Map<String, int> _read(Map<String, dynamic>? json) => {
    for (final e in (json ?? const {}).entries) e.key: e.value as int,
  };
}
