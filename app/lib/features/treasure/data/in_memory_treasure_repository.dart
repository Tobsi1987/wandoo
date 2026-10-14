import 'package:wandoo/core/memory/memory_value.dart';
import 'package:wandoo/features/treasure/domain/treasure_chest.dart';
import 'package:wandoo/features/treasure/domain/treasure_repository.dart';

/// Schatzkiste nur im Speicher, für Tests und die Demo.
class InMemoryTreasureRepository extends MemoryValue<TreasureChest>
    implements TreasureRepository {
  InMemoryTreasureRepository([super.value = const TreasureChest()]);
}
