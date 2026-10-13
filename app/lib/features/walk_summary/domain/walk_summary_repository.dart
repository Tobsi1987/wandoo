import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';

/// Gespeicherte Zusammenfassungen der Gänge.
abstract interface class WalkSummaryRepository {
  Future<void> save(WalkSummary summary);

  /// Die neueste Zusammenfassung, die noch nicht weggeklickt wurde.
  Stream<WalkSummary?> watchLatestUnseen();

  Future<void> markSeen(String walkId);
}
