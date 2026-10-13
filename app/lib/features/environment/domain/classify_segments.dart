import 'package:geo_engine/geo_engine.dart';

/// Zählt neue Abschnitte je Umgebungstyp, als Futter für das Wesen.
class ClassifySegments {
  const ClassifySegments({this.classifier = const EnvironmentClassifier()});

  final EnvironmentClassifier classifier;

  Map<EnvironmentType, int> call(List<RoadSegment> segments) =>
      classifier.countByType(segments);

  /// Umgebung je Abschnitt.
  Map<RoadSegment, EnvironmentType> each(List<RoadSegment> segments) => {
    for (final s in segments) s: classifier.classify(s),
  };
}
