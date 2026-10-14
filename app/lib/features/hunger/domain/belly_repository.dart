import 'package:wandoo/features/hunger/domain/belly.dart';
import 'package:wandoo/features/hunger/domain/farewell.dart';

/// Speichert den Hungerbalken je Wesen (`Creature.lineKey`) und einen
/// noch ungelesenen Abschiedsbrief.
abstract interface class BellyRepository {
  /// null, solange das Wesen noch keinen Balken hat.
  Future<Belly?> load(String lineKey);

  Future<void> save(Belly belly);

  Stream<Belly?> watch(String lineKey);

  Future<void> leaveLetter(Farewell? farewell);

  Stream<Farewell?> watchLetter();
}
