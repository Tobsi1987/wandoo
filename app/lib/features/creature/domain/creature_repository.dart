import 'package:wandoo/features/creature/domain/creature.dart';

/// Speichert das Wesen. Die Umsetzung liegt in `data/`.
abstract interface class CreatureRepository {
  Future<Creature> load();

  Future<void> save(Creature creature);
}
