import 'package:wandoo/features/creature/domain/creature.dart';

/// Ein Wesen im Winterschlaf in der Höhle: Es braucht weder Gänge noch
/// Futter, bis es wieder aufgeweckt wird.
class Sleeper {
  const Sleeper({required this.creature, required this.since});

  final Creature creature;

  /// Seit wann es schläft.
  final DateTime since;
}

/// Speichert, wer in der Höhle schläft. Es ist immer nur ein Wesen aktiv.
abstract interface class DenRepository {
  Future<Sleeper?> load();

  Future<void> save(Sleeper sleeper);

  Stream<Sleeper?> watch();
}
