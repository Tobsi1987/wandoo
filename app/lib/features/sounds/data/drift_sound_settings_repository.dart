import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/sounds/domain/sound_settings_repository.dart';

/// Speichert "Laute aus" in den Einstellungen der Datenbank.
class DriftSoundSettingsRepository implements SoundSettingsRepository {
  DriftSoundSettingsRepository(this._db);

  final AppDatabase _db;
  static const _key = 'sounds.muted';

  @override
  Future<bool> muted() async =>
      (await _query().getSingleOrNull())?.value == 'true';

  @override
  Stream<bool> watchMuted() =>
      _query().watchSingleOrNull().map((row) => row?.value == 'true');

  @override
  Future<void> setMuted({required bool muted}) => _db
      .into(_db.preferences)
      .insertOnConflictUpdate(Preference(key: _key, value: '$muted'));

  SimpleSelectStatement<$PreferencesTable, Preference> _query() =>
      _db.select(_db.preferences)..where((t) => t.key.equals(_key));
}
