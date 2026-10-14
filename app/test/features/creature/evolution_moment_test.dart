import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/presentation/celebration/evolution_moment.dart';

void main() {
  final own = Creature(food: GrowthStage.adult.foodNeeded, speciesId: 'funkel');

  Widget app({required int? stage, required bool hold, List<int>? seen}) =>
      CreatureEvolution(
        creature: own,
        stage: stage,
        child: CelebrationStage(
          hold: hold,
          child: EvolutionMoment(
            creature: own,
            size: 100,
            child: Builder(
              builder: (context) {
                seen?.add(CreatureEvolution.of(context, own));
                return const SizedBox();
              },
            ),
          ),
        ),
      );

  testWidgets('entwickelt sich erst, wenn kein Fenster mehr offen ist', (
    tester,
  ) async {
    final seen = <int>[];
    await tester.pumpWidget(app(stage: 1, hold: false, seen: seen));
    await tester.pumpWidget(app(stage: 2, hold: true, seen: seen));
    expect(seen.last, 1);
    await tester.pumpWidget(app(stage: 2, hold: false, seen: seen));
    expect(seen.last, 2);
  });

  testWidgets('beim Laden der Stufe keine scheinbare Entwicklung', (
    tester,
  ) async {
    final seen = <int>[];
    await tester.pumpWidget(app(stage: null, hold: true, seen: seen));
    await tester.pumpWidget(app(stage: 3, hold: true, seen: seen));
    expect(seen.last, 3);
  });
}
