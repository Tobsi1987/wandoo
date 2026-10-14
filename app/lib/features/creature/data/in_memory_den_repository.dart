import 'package:wandoo/core/memory/memory_value.dart';
import 'package:wandoo/features/creature/domain/den_repository.dart';

/// Hält das schlafende Wesen nur im Speicher. Für Tests und die Demo.
class InMemoryDenRepository extends MemoryValue<Sleeper?>
    implements DenRepository {
  InMemoryDenRepository([super.value]);
}
