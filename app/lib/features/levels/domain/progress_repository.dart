import 'package:wandoo/features/levels/domain/progress.dart';

/// Speichert die Erfahrung je Wesen (`Creature.lineKey`), damit ein Wesen
/// im Winterschlaf sein Level behält.
abstract interface class ProgressRepository {
  /// Für ein neues Wesen: ohne Erfahrung.
  Future<Progress> load(String lineKey);

  Future<void> save(Progress progress);

  Stream<Progress> watch(String lineKey);
}
