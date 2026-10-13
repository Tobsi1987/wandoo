import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/diary/diary.dart';

void main() {
  const remember = RememberWalk();
  const start = GeoPoint(52, 7);
  const end = GeoPoint(52.01, 7.01);
  WalkFacts facts({
    bool first = false,
    bool egg = false,
    bool hatched = false,
    String? grewTo,
    int before = 0,
    int after = 500,
  }) => WalkFacts(
    walkId: 'w',
    creatureKey: 'erstes',
    finishedAt: DateTime(2026, 10, 13),
    track: const [start, GeoPoint(52.005, 7.005), end],
    metersBefore: before,
    metersAfter: after,
    firstWalk: first,
    withEgg: egg,
    hatched: hatched,
    grewTo: grewTo,
  );

  test('erster Ausflug mit dem Ei und Schlüpfen, mit Ort', () {
    final m = remember.memories(facts(first: true, egg: true, hatched: true));
    expect(m.map((e) => e.title), [
      'Erster Ausflug mit dem Ei',
      'Hier bist du geschlüpft',
    ]);
    expect(m.first.place, start);
    expect(m.last.place, end);
  });

  test('erster gemeinsamer Gang, Wachsen und runde Kilometer', () {
    final m = remember.memories(
      facts(first: true, grewTo: 'Jungtier', before: 900, after: 5200),
    );
    expect(m.map((e) => e.title), [
      'Unser erster gemeinsamer Gang',
      'Gewachsen: Jungtier',
      'Zusammen 1 km gelaufen',
      'Zusammen 5 km gelaufen',
    ]);
  });

  test('ein ganz normaler Gang bringt keine Erinnerung', () {
    expect(remember.memories(facts(before: 1200, after: 1800)), isEmpty);
  });

  test('der Eintrag kennt die Strecke dieses Gangs, die Spur wird dünner', () {
    expect(remember.walk(facts(before: 1200, after: 1800)).meters, 600);
    final long = [for (var i = 0; i < 1000; i++) GeoPoint(52, 7 + i / 1e4)];
    final thin = remember.thin(long);
    expect(thin, hasLength(150));
    expect(thin.first, long.first);
    expect(thin.last, long.last);
  });
}
