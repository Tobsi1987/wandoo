import 'package:geo_engine/geo_engine.dart';
import 'package:test/test.dart';

RoadSegment segment(Map<String, String> tags) => RoadSegment(
  id: tags.toString(),
  start: const GeoPoint(0, 0),
  end: const GeoPoint(0, 0.001),
  areaTags: tags,
);

void main() {
  const classifier = EnvironmentClassifier();

  test('erkennt die vier MVP-Umgebungen', () {
    expect(
      classifier.classify(segment({'landuse': 'forest'})),
      EnvironmentType.forest,
    );
    expect(
      classifier.classify(segment({'waterway': 'river'})),
      EnvironmentType.water,
    );
    expect(
      classifier.classify(segment({'landuse': 'farmland'})),
      EnvironmentType.field,
    );
    expect(
      classifier.classify(segment({'landuse': 'residential'})),
      EnvironmentType.city,
    );
  });

  test('unbekannte Tags ergeben unknown', () {
    expect(
      classifier.classify(segment({'amenity': 'bench'})),
      EnvironmentType.unknown,
    );
  });

  test('zählt Abschnitte je Umgebung', () {
    final counts = classifier.countByType([
      segment({'landuse': 'forest'}),
      segment({'natural': 'wood'}),
      segment({'natural': 'water'}),
    ]);
    expect(counts, {EnvironmentType.forest: 2, EnvironmentType.water: 1});
  });
}
