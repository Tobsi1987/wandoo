import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/bath/domain/mud_repository.dart';

/// Speichert den Matsch je Wesen in den Einstellungen der Datenbank.
class DriftMudRepository implements MudRepository {
  DriftMudRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static String _key(String lineKey) => 'bath.mud.$lineKey';

  @override
  Future<int> load(String lineKey) async =>
      int.tryParse(await _store.get(_key(lineKey)) ?? '') ?? 0;

  @override
  Future<void> save(String lineKey, int level) =>
      _store.put(_key(lineKey), '$level');

  @override
  Stream<int> watch(String lineKey) =>
      _store.watch(_key(lineKey)).map((v) => int.tryParse(v ?? '') ?? 0);
}
