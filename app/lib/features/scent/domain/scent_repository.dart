import 'package:wandoo/features/scent/domain/scent.dart';

/// Merkt sich die eine Spur, der das Wesen gerade folgt.
abstract interface class ScentRepository {
  Future<Scent?> load();

  Future<void> save(Scent scent);

  Future<void> clear();

  /// Die aktuelle Spur jetzt und nach jeder Änderung.
  Stream<Scent?> watch();
}
