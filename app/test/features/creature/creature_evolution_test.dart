import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';

void main() {
  testWidgets('Stufe gilt nur für das eigene geschlüpfte Wesen', (
    tester,
  ) async {
    final own = Creature(
      food: GrowthStage.adult.foodNeeded,
      speciesId: 'funkel',
    );
    final other = Creature(
      food: GrowthStage.adult.foodNeeded,
      speciesId: 'moosel',
    );
    final seen = <int>[];
    await tester.pumpWidget(
      CreatureEvolution(
        creature: own,
        stage: 3,
        child: Builder(
          builder: (context) {
            seen
              ..add(CreatureEvolution.of(context, own))
              ..add(CreatureEvolution.of(context, other))
              ..add(CreatureEvolution.of(context, const Creature()));
            return const SizedBox();
          },
        ),
      ),
    );
    expect(seen, [3, 1, 1]);
    expect(CreatureEvolution.scaleFor(3), greaterThan(1));
  });
}
