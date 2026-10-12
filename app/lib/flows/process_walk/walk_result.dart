import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/creature.dart';

/// Was ein Gang gebracht hat, für Zusammenfassung, Widget und Teilen.
class WalkResult {
  const WalkResult({
    required this.newSegmentCount,
    required this.byEnvironment,
    required this.creature,
  });

  final int newSegmentCount;
  final Map<EnvironmentType, int> byEnvironment;
  final Creature creature;
}
