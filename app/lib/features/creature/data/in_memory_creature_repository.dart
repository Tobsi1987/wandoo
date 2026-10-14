import 'package:wandoo/core/memory/memory_value.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/creature_repository.dart';

/// Hält das Wesen nur im Speicher. Für Tests und die Demo.
class InMemoryCreatureRepository extends MemoryValue<Creature>
    implements CreatureRepository {
  InMemoryCreatureRepository([super.value = const Creature()]);
}
