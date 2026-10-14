import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/achievements/data/stats_json.dart';
import 'package:wandoo/features/achievements/domain/lifetime_stats.dart';
import 'package:wandoo/features/achievements/domain/stats_repository.dart';

/// Speichert die Zahlen als JSON in den Einstellungen.
class DriftStatsRepository implements StatsRepository {
  DriftStatsRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static const _key = 'achievements.stats';

  @override
  Future<LifetimeStats> load() async => _read(await _store.getJson(_key));

  @override
  Stream<LifetimeStats> watch() => _store.watchJson(_key).map(_read);

  @override
  Future<void> save(LifetimeStats stats) =>
      _store.putJson(_key, statsToJson(stats));

  static LifetimeStats _read(Map<String, dynamic>? json) =>
      json == null ? const LifetimeStats() : statsFromJson(json);
}
