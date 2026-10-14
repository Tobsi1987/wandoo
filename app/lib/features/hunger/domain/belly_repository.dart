import 'package:wandoo/features/hunger/domain/belly.dart';
import 'package:wandoo/features/hunger/domain/farewell.dart';

/// Speichert den Hungerbalken und einen noch ungelesenen Abschiedsbrief.
abstract interface class BellyRepository {
  Future<Belly?> load();

  Future<void> save(Belly belly);

  Stream<Belly?> watch();

  Future<void> leaveLetter(Farewell? farewell);

  Stream<Farewell?> watchLetter();
}
