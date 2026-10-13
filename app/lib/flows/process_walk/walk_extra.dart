import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';

/// Was ein Gang ergeben hat, für Extras wie Fundstücke oder Abenteuer.
class WalkOutcome {
  const WalkOutcome({
    required this.track,
    required this.summary,
    required this.newSegmentsByEnvironment,
  });

  final Track track;
  final WalkSummary summary;
  final Map<EnvironmentType, int> newSegmentsByEnvironment;
}

/// Ein Zusatz, der nach jedem Gang läuft und Zeilen für die
/// Zusammenfassung beisteuert. So wächst `ProcessWalk` nicht mit jedem
/// neuen Feature.
abstract interface class WalkExtra {
  Future<List<String>> onWalk(WalkOutcome outcome);
}
