import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';

/// Was ein Gang gebracht hat, für Zusammenfassung, Widget und Teilen.
class WalkResult {
  const WalkResult({required this.summary, required this.creature});

  final WalkSummary summary;
  final Creature creature;

  int get newSegmentCount => summary.newSegmentCount;
}
