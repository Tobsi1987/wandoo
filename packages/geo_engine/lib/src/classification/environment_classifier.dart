import 'package:geo_engine/src/classification/osm_environment_rules.dart';
import 'package:geo_engine/src/model/environment_type.dart';
import 'package:geo_engine/src/model/road_segment.dart';

/// Bestimmt den Umgebungstyp eines Abschnitts aus seinen Flächen-Tags.
class EnvironmentClassifier {
  const EnvironmentClassifier({this.rules = osmEnvironmentRules});

  final List<(String, String, EnvironmentType)> rules;

  EnvironmentType classify(RoadSegment segment) {
    for (final (key, value, type) in rules) {
      final tag = segment.areaTags[key];
      if (tag != null && (value == '*' || tag == value)) return type;
    }
    return EnvironmentType.unknown;
  }

  /// Zählt, wie viele Abschnitte auf welchen Umgebungstyp fallen.
  Map<EnvironmentType, int> countByType(Iterable<RoadSegment> segments) {
    final counts = <EnvironmentType, int>{};
    for (final segment in segments) {
      counts.update(classify(segment), (n) => n + 1, ifAbsent: () => 1);
    }
    return counts;
  }
}
