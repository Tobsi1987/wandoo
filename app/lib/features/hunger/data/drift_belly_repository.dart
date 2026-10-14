import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/hunger/domain/belly.dart';
import 'package:wandoo/features/hunger/domain/belly_repository.dart';
import 'package:wandoo/features/hunger/domain/farewell.dart';

/// Speichert Balken und Brief als JSON in den Einstellungen.
class DriftBellyRepository implements BellyRepository {
  DriftBellyRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static String _bellyKey(String lineKey) => 'hunger.belly.$lineKey';
  static const _letterKey = 'hunger.farewell';

  @override
  Future<Belly?> load(String lineKey) async =>
      _belly(await _store.getJson(_bellyKey(lineKey)));

  @override
  Stream<Belly?> watch(String lineKey) =>
      _store.watchJson(_bellyKey(lineKey)).map(_belly);

  @override
  Future<void> save(Belly belly) => _store.putJson(_bellyKey(belly.lineKey), {
    'line': belly.lineKey,
    'meters': belly.meters,
    'at': belly.at.toIso8601String(),
  });

  @override
  Future<void> leaveLetter(Farewell? farewell) => farewell == null
      ? _store.remove(_letterKey)
      : _store.putJson(_letterKey, {
          'species': farewell.speciesId,
          'at': farewell.at.toIso8601String(),
        });

  @override
  Stream<Farewell?> watchLetter() => _store
      .watchJson(_letterKey)
      .map(
        (json) => json == null
            ? null
            : Farewell(
                speciesId: json['species'] as String,
                at: DateTime.parse(json['at'] as String),
              ),
      );

  static Belly? _belly(Map<String, dynamic>? json) => json == null
      ? null
      : Belly(
          lineKey: json['line'] as String,
          meters: (json['meters'] as num).toDouble(),
          at: DateTime.parse(json['at'] as String),
        );
}
