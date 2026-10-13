import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/districts/districts.dart';
import 'package:wandoo/features/districts/domain/puzzle.dart';

/// Ostwärts laufende Straße aus [n] Stücken à rund 70 m ab [lat]/[lon].
List<RoadSegment> street(String name, double lat, double lon, int n) => [
  for (var i = 0; i < n; i++)
    RoadSegment(
      id: '$name$i',
      start: GeoPoint(lat, lon + i * 0.001),
      end: GeoPoint(lat, lon + (i + 1) * 0.001),
    ),
];

void main() {
  const progress = DistrictProgress();
  final a = street('a', 50.005, 8, 10);
  final b = street('b', 50.015, 8, 10);

  test('Abschnitte gehören zum Viertel ihrer Mitte', () {
    final states = progress([...a, ...b], {'a0', 'a1'});
    expect(states.keys, {const District(5000, 800), const District(5001, 800)});
    expect(states[const District(5000, 800)]!.percent, 20);
    expect(states[const District(5001, 800)]!.share, 0);
  });

  test('ab 80 % gibt es das Abzeichen, wenige Wege sind Wildnis', () {
    final known = {for (var i = 0; i < 8; i++) 'a$i'};
    final state = progress(a, known)[const District(5000, 800)]!;
    expect(state.badge, isTrue);
    final wild = progress(street('w', 50.005, 8, 2), {'w0', 'w1'});
    expect(wild.values.single.wild, isTrue);
    expect(wild.values.single.badge, isFalse);
  });

  test('neues Abzeichen genau beim Überschreiten der Grenze', () {
    final seven = {for (var i = 0; i < 7; i++) 'a$i'};
    final badges = progress.newBadges(a, {...seven, 'a7'}, {'a7'});
    expect(badges, [const District(5000, 800)]);
    expect(progress.newBadges(a, {...seven, 'a7', 'a8'}, {'a8'}), isEmpty);
  });

  test('Puzzle: 25 Teile, Norden oben, mit Standort', () {
    final known = {for (var i = 0; i < 9; i++) 'a$i'};
    final puzzle = Puzzle.around(const GeoPoint(50.006, 8.004), [
      ...a,
      ...b,
    ], known);
    expect(puzzle.pieces, hasLength(25));
    expect(puzzle.here, const District(5000, 800));
    expect(puzzle.pieces.last.district, const District(5000, 804));
    expect(puzzle.pieces.first.district, const District(5004, 800));
    expect((puzzle.placed, puzzle.placeable), (1, 2));
  });

  test('Namen sind fest und kindgerecht', () {
    final name = districtName(const District(5000, 800));
    expect(name, districtName(const District(5000, 800)));
    expect(name, isNot(districtName(const District(5000, 801))));
    expect(name, matches(RegExp(r'^[A-ZÄÖÜ][a-zäöüß]+$')));
  });
}
