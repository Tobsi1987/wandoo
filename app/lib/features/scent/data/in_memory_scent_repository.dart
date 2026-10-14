import 'package:wandoo/core/memory/memory_value.dart';
import 'package:wandoo/features/scent/domain/scent.dart';
import 'package:wandoo/features/scent/domain/scent_repository.dart';

/// Hält die Spur nur im Speicher, für Demo und Tests. [current] gibt sie
/// sofort, ohne zu warten (für die simulierten Gänge der Demo).
class InMemoryScentRepository extends MemoryValue<Scent?>
    implements ScentRepository {
  InMemoryScentRepository() : super(null);

  @override
  Future<void> clear() => save(null);
}
