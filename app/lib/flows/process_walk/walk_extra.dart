import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';

/// Was ein Gang ergeben hat, für Extras wie Fundstücke oder Abenteuer.
class WalkOutcome {
  const WalkOutcome({
    required this.track,
    required this.summary,
    required this.newSegmentsByEnvironment,
    this.nearby = const [],
    this.freshIds = const {},
    this.before = const Creature(),
    this.after = const Creature(),
  });

  final Track track;
  final WalkSummary summary;
  final Map<EnvironmentType, int> newSegmentsByEnvironment;

  /// Alle Abschnitte der Kartenkacheln rund um den Gang.
  final List<RoadSegment> nearby;

  /// Abschnitte, die mit diesem Gang neu bekannt wurden.
  final Set<String> freshIds;

  /// Das Wesen vor und nach dem Gang (gefüttert, Meter gezählt).
  final Creature before;
  final Creature after;
}

/// Ein Zusatz, der nach jedem Gang läuft und Zeilen für die
/// Zusammenfassung beisteuert. So wächst `ProcessWalk` nicht mit jedem
/// neuen Feature.
abstract interface class WalkExtra {
  Future<List<String>> onWalk(WalkOutcome outcome);
}
