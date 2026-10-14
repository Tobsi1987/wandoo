import 'package:wandoo/core/memory/memory_value.dart';
import 'package:wandoo/features/adventures/domain/adventure_repository.dart';
import 'package:wandoo/features/adventures/domain/weekly_adventure.dart';

/// Abenteuer nur im Speicher, für Tests und die Demo.
class InMemoryAdventureRepository extends MemoryValue<WeeklyAdventure?>
    implements AdventureRepository {
  InMemoryAdventureRepository() : super(null);
}
