import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_celebration.dart';

void main() {
  const egg = Creature(food: 19);
  const hatched = Creature(food: 25, speciesId: 'funkel');

  Widget host(
    Creature c, {
    bool hold = false,
    void Function(CelebrationMoment, Creature)? onPlay,
  }) => MaterialApp(
    home: CelebrationStage(
      hold: hold,
      onPlay: onPlay,
      child: CreatureCelebration(
        creature: c,
        size: 100,
        builder: (c) => Text(c.hatched ? 'Wesen' : 'Ei'),
      ),
    ),
  );

  tearDown(() => CreatureFigure.animate = false);

  testWidgets(
    'beim Schlüpfen platzt das Ei, das Wesen springt heraus und grüßt',
    (tester) async {
      CreatureFigure.animate = true;
      await tester.pumpWidget(host(egg));
      await tester.pumpWidget(host(hatched));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Ei'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.text('Wesen'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1500));
      expect(find.text('Hallo!'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Hallo!'), findsNothing);
      expect(find.text('Wesen'), findsOneWidget);
      expect(find.text('Ei'), findsNothing);
    },
  );

  testWidgets('ein Hüpfer mitten im Schlüpfen lässt das Ei nicht stehen', (
    tester,
  ) async {
    CreatureFigure.animate = true;
    await tester.pumpWidget(host(egg));
    await tester.pumpWidget(host(hatched));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpWidget(host(hatched.copyWith(food: 30)));
    await tester.pumpAndSettle();
    expect(find.text('Wesen'), findsOneWidget);
    expect(find.text('Ei'), findsNothing);
  });

  testWidgets('ohne Animation steht das Wesen sofort da', (tester) async {
    await tester.pumpWidget(host(egg));
    await tester.pumpWidget(host(hatched));
    await tester.pump();
    expect(find.text('Wesen'), findsOneWidget);
    expect(find.text('Ei'), findsNothing);
  });

  testWidgets('nach dem Fressen hüpft es und landet wieder', (tester) async {
    CreatureFigure.animate = true;
    await tester.pumpWidget(host(hatched));
    await tester.pumpWidget(host(hatched.copyWith(food: 30)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    final moved = tester.getTopLeft(find.text('Wesen'));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('Wesen')).dy, greaterThan(moved.dy));
  });

  testWidgets('angehalten bleibt das Ei, bis die Bühne frei ist', (
    tester,
  ) async {
    CreatureFigure.animate = true;
    final played = <CelebrationMoment>[];
    await tester.pumpWidget(host(egg, hold: true));
    await tester.pumpWidget(
      host(hatched, hold: true, onPlay: (m, _) => played.add(m)),
    );
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Ei'), findsOneWidget);
    expect(played, isEmpty);

    await tester.pumpWidget(host(hatched, onPlay: (m, _) => played.add(m)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1300));
    expect(played, [CelebrationMoment.hatch]);
    expect(find.text('Wesen'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Ei'), findsNothing);
  });
}
