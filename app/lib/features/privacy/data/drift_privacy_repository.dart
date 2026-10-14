import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/privacy/domain/privacy_choices.dart';
import 'package:wandoo/features/privacy/domain/privacy_repository.dart';

/// Speichert die Datenschutz-Einstellungen in der Datenbank.
class DriftPrivacyRepository implements PrivacyRepository {
  DriftPrivacyRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static const _key = 'privacy.choices';

  @override
  Stream<PrivacyChoices> watch() => _store
      .watchJson(_key)
      .map(
        (json) => json == null
            ? const PrivacyChoices()
            : PrivacyChoices.fromJson(json),
      );

  @override
  Future<void> save(PrivacyChoices choices) =>
      _store.putJson(_key, choices.toJson());
}
