import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/levels/domain/progress.dart';
import 'package:wandoo/features/levels/domain/progress_repository.dart';

/// Speichert die Erfahrung als JSON in den Einstellungen.
class DriftProgressRepository implements ProgressRepository {
  DriftProgressRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static String _key(String lineKey) => 'levels.progress.$lineKey';

  @override
  Future<Progress> load(String lineKey) async =>
      _read(lineKey, await _store.getJson(_key(lineKey)));

  @override
  Stream<Progress> watch(String lineKey) =>
      _store.watchJson(_key(lineKey)).map((json) => _read(lineKey, json));

  @override
  Future<void> save(Progress progress) => _store.putJson(
    _key(progress.lineKey),
    {'line': progress.lineKey, 'xp': progress.xp, 'news': progress.news},
  );

  static Progress _read(String lineKey, Map<String, dynamic>? json) =>
      json == null
      ? Progress(lineKey: lineKey)
      : Progress(
          lineKey: lineKey,
          xp: json['xp'] as int,
          news: [for (final n in json['news'] as List<dynamic>) n as String],
        );
}
