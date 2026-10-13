import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/presentation/painting/body_geometry.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_painter.dart';

void main() {
  test('Merkmale werden ab dem ersten Punkt sichtbar und wachsen bis 3', () {
    expect(traitLevel(0), 0);
    expect(traitLevel(1), 1);
    expect(traitLevel(12), 2);
    expect(traitLevel(80), 3);
  });

  final creatures = <String, Creature>{
    'Ei': const Creature(food: 5),
    'Jungtier mit allem': const Creature(
      food: 40,
      traitPoints: {
        Trait.moss: 12,
        Trait.fins: 3,
        Trait.lanterns: 30,
        Trait.wheatEars: 9,
      },
    ),
    'Ausgewachsen, träge': Creature(
      food: 150,
      traitPoints: const {Trait.fins: 90},
      lastFedAt: DateTime(2020),
    ),
  };

  for (final MapEntry(key: name, value: creature) in creatures.entries) {
    testWidgets('zeichnet $name ohne Fehler', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CreatureAvatar(creature: creature)),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is CustomPaint && w.painter is CreaturePainter,
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
