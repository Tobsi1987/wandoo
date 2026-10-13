import 'dart:io';

import 'package:geo_engine/geo_engine.dart';
import 'package:test/test.dart';

void main() {
  final segments = const RegionBuilder().fromOverpassJson(
    File('test/fixtures/overpass_sample.json').readAsStringSync(),
  );
  RoadSegment byId(String id) => segments.firstWhere((s) => s.id == id);
  const classifier = EnvironmentClassifier();

  test('teilt Wege an der Kreuzung', () {
    expect(segments.map((s) => s.id), ['w1-0', 'w1-1', 'w2-0', 'w2-1']);
  });

  test('Straßenname wird zur Straßen-ID, sonst der Weg', () {
    expect(byId('w1-0').streetId, 'Hauptstraße');
    expect(byId('w2-0').streetId, 'w2');
  });

  test('kleinste umgebende Fläche gewinnt', () {
    expect(classifier.classify(byId('w1-1')), EnvironmentType.forest);
    expect(classifier.classify(byId('w2-1')), EnvironmentType.city);
  });

  test('Loch im Multipolygon zählt nicht zur Fläche', () {
    expect(byId('w1-0').areaTags, isEmpty);
  });

  test('Bach in der Nähe macht den Abschnitt zum Wasserweg', () {
    expect(byId('w2-0').areaTags['waterway'], 'stream');
    expect(classifier.classify(byId('w2-0')), EnvironmentType.water);
  });

  test('Abfrage enthält das Rechteck und Geometrie', () {
    final query = overpassQuery(50, 8, 50.05, 8.05);
    expect(query, contains('(50.0,8.0,50.05,8.05)'));
    expect(query, endsWith('out geom;'));
  });
}
