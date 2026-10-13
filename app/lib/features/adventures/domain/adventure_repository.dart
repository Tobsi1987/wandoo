import 'package:wandoo/features/adventures/domain/weekly_adventure.dart';

/// Speichert die Abenteuer der aktuellen Woche.
abstract interface class AdventureRepository {
  /// Null, solange es noch nie Abenteuer gab.
  Future<WeeklyAdventure?> load();

  Future<void> save(WeeklyAdventure adventure);

  Stream<WeeklyAdventure?> watch();
}
