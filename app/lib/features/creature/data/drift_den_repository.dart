import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/creature/data/creature_json.dart';
import 'package:wandoo/features/creature/domain/den_repository.dart';

/// Speichert das schlafende Wesen als JSON in den Einstellungen.
class DriftDenRepository implements DenRepository {
  DriftDenRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static const _key = 'den.sleeper';

  @override
  Future<Sleeper?> load() async => _read(await _store.getJson(_key));

  @override
  Stream<Sleeper?> watch() => _store.watchJson(_key).map(_read);

  @override
  Future<void> save(Sleeper sleeper) => _store.putJson(_key, {
    'creature': creatureToJson(sleeper.creature),
    'since': sleeper.since.toIso8601String(),
  });

  static Sleeper? _read(Map<String, dynamic>? json) => json == null
      ? null
      : Sleeper(
          creature: creatureFromJson(json['creature'] as Map<String, dynamic>),
          since: DateTime.parse(json['since'] as String),
        );
}
