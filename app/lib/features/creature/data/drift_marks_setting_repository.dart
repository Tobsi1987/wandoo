import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/creature/domain/marks_setting_repository.dart';

/// Speichert "Spuren zeigen" in den Einstellungen der Datenbank.
class DriftMarksSettingRepository implements MarksSettingRepository {
  DriftMarksSettingRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static const _key = 'creature.marks';

  @override
  Stream<bool> watchShown() => _store.watch(_key).map((v) => v != 'false');

  @override
  Future<void> setShown({required bool shown}) => _store.put(_key, '$shown');
}
