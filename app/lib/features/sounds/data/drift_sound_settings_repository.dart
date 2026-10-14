import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/sounds/domain/sound_settings_repository.dart';

/// Speichert "Laute aus" in den Einstellungen der Datenbank.
class DriftSoundSettingsRepository implements SoundSettingsRepository {
  DriftSoundSettingsRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static const _key = 'sounds.muted';

  @override
  Future<bool> muted() async => await _store.get(_key) == 'true';

  @override
  Stream<bool> watchMuted() => _store.watch(_key).map((v) => v == 'true');

  @override
  Future<void> setMuted({required bool muted}) => _store.put(_key, '$muted');
}
