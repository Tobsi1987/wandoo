import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/scent/domain/scent_hint.dart';
import 'package:wandoo/features/scent/scent.dart';

/// Ein Punkt [north] Meter nördlich und [east] Meter östlich von 52/7.
GeoPoint at(double north, double east) =>
    GeoPoint(52 + north / 111195, 7 + east / (111195 * cos(52 * pi / 180)));

void main() {
  final now = DateTime(2026, 10, 14, 9);

  group('PickScent', () {
    test('nimmt eine Straße in Gehweite, nicht direkt vor der Tür', () {
      final spots = <ScentSpot>[
        (at: at(20, 0), environment: EnvironmentType.city),
        (at: at(300, 0), environment: EnvironmentType.forest),
        (at: at(2000, 0), environment: EnvironmentType.water),
      ];
      for (var seed = 0; seed < 10; seed++) {
        final scent = const PickScent()(at(0, 0), spots, now, Random(seed))!;
        expect(scent.environment, EnvironmentType.forest);
        expect(scent.createdAt, now);
      }
    });

    test('gibt es dort nichts, gilt ein weiterer Kreis', () {
      final spots = <ScentSpot>[(at: at(700, 0), environment: null)];
      final scent = const PickScent()(at(0, 0), spots, now, Random(1));
      expect(scent?.target, at(700, 0));
    });

    test('ganz ohne unbekannte Straßen riecht es nichts', () {
      expect(const PickScent()(at(0, 0), const [], now, Random(1)), isNull);
    });
  });

  test('Scent.reachedBy: nur wer nah genug vorbeikommt', () {
    final scent = Scent(target: at(100, 0), createdAt: now);
    Track track(List<GeoPoint> points) =>
        Track(id: 't', points: [for (final p in points) TrackPoint(p, now)]);
    expect(scent.reachedBy(track([at(0, 0), at(60, 0)])), isFalse);
    expect(scent.reachedBy(track([at(0, 0), at(90, 10)])), isTrue);
  });

  group('ScentHint', () {
    test('heiß und kalt nach Entfernung', () {
      Heat heat(double m) => ScentHint.toward(at(m, 0), at(0, 0)).heat;
      expect(heat(10), Heat.found);
      expect(heat(60), Heat.hot);
      expect(heat(150), Heat.warm);
      expect(heat(300), Heat.cool);
      expect(heat(800), Heat.cold);
    });

    test('Pfeil bezogen auf die Gehrichtung', () {
      // Man geht nach Norden; der Fund liegt im Osten: rechts.
      final right = ScentHint.toward(
        at(0, 200),
        at(0, 0),
        cameFrom: at(-20, 0),
      );
      expect(right.turn, closeTo(pi / 2, 0.02));
      // Fund liegt hinter einem.
      final behind = ScentHint.toward(
        at(-200, 0),
        at(0, 0),
        cameFrom: at(-20, 0),
      );
      expect(behind.turn!.abs(), closeTo(pi, 0.02));
      // Ohne Gehrichtung kein Pfeil.
      expect(ScentHint.toward(at(200, 0), at(0, 0)).turn, isNull);
    });
  });
}
