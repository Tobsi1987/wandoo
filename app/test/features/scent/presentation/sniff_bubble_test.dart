import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/scent/scent.dart';
import 'package:wandoo/features/tracking/application/tracking_controller.dart';
import 'package:wandoo/features/tracking/tracking.dart';

GeoPoint at(double north, double east) =>
    GeoPoint(52 + north / 111195, 7 + east / (111195 * cos(52 * pi / 180)));

class _Session extends TrackingController {
  _Session(this.session);
  final WalkSession session;
  @override
  WalkSession build() => session;
}

Widget host(WalkSession session, {Creature? creature}) => ProviderScope(
  overrides: [
    creatureProvider.overrideWith(
      (ref) => Stream.value(
        creature ?? const Creature(food: 20, speciesId: 'moosel'),
      ),
    ),
    scentProvider.overrideWith(
      (ref) => Stream.value(
        Scent(target: at(150, 0), createdAt: DateTime(2026, 10, 14)),
      ),
    ),
    trackingControllerProvider.overrideWith(() => _Session(session)),
  ],
  child: const MaterialApp(home: Scaffold(body: SniffBubble())),
);

void main() {
  testWidgets('vor dem Gang: das Wesen riecht etwas', (tester) async {
    await tester.pumpWidget(host(const WalkIdle()));
    await tester.pump();
    expect(find.textContaining('Moosel riecht etwas'), findsOneWidget);
  });

  testWidgets('unterwegs: warm, mit Pfeil geradeaus', (tester) async {
    await tester.pumpWidget(
      host(
        WalkRecording(
          startedAt: DateTime(2026, 10, 14),
          distanceMeters: 40,
          position: at(0, 0),
          cameFrom: at(-20, 0),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('☀️ Warm'), findsOneWidget);
    expect(find.text('noch etwa 150 m'), findsOneWidget);
    expect(find.byIcon(Icons.navigation), findsOneWidget);
    expect(find.bySemanticsLabel('☀️ Warm, geradeaus'), findsOneWidget);
  });

  testWidgets('Eier riechen noch nichts', (tester) async {
    await tester.pumpWidget(
      host(const WalkIdle(), creature: const Creature(food: 5)),
    );
    await tester.pump();
    expect(find.byType(Text), findsNothing);
  });
}
