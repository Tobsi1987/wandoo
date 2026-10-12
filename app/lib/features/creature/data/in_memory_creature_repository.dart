import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/creature_repository.dart';

/// Hält das Wesen nur im Speicher. Platzhalter, bis die Drift-Datenbank in
/// `core/database/` steht; dann kommt `DriftCreatureRepository` daneben.
class InMemoryCreatureRepository implements CreatureRepository {
  Creature _creature = const Creature();

  @override
  Future<Creature> load() async => _creature;

  @override
  Future<void> save(Creature creature) async => _creature = creature;
}
