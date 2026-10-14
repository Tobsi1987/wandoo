import 'package:wandoo/core/memory/memory_value.dart';
import 'package:wandoo/features/privacy/domain/privacy_choices.dart';
import 'package:wandoo/features/privacy/domain/privacy_repository.dart';

/// Hält die Datenschutz-Einstellungen nur im Speicher, für Demo und Tests.
class InMemoryPrivacyRepository extends MemoryValue<PrivacyChoices>
    implements PrivacyRepository {
  InMemoryPrivacyRepository([super.value = const PrivacyChoices()]);
}
