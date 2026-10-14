import 'package:wandoo/features/privacy/domain/privacy_choices.dart';

/// Merkt sich die Datenschutz-Einstellungen.
abstract interface class PrivacyRepository {
  /// Erst die jetzigen Einstellungen, dann jede Änderung.
  Stream<PrivacyChoices> watch();

  Future<void> save(PrivacyChoices choices);
}
