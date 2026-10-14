import 'package:wandoo/core/memory/memory_value.dart';
import 'package:wandoo/features/creature/domain/marks_setting_repository.dart';

/// Hält "Spuren zeigen" nur im Speicher, für Demo und Tests.
class InMemoryMarksSettingRepository extends MemoryValue<bool>
    implements MarksSettingRepository {
  InMemoryMarksSettingRepository() : super(true);

  @override
  Stream<bool> watchShown() => watch();

  @override
  Future<void> setShown({required bool shown}) => save(shown);
}
