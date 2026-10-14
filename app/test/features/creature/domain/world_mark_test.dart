import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/domain/trait.dart';
import 'package:wandoo/features/creature/domain/world_mark.dart';

void main() {
  Creature hatched(Map<Trait, int> points) => Creature(
    food: GrowthStage.juvenile.foodNeeded,
    speciesId: 'funkel',
    traitPoints: points,
  );

  test('Eier und Wesen mit wenig neuen Wegen haben keine Spur', () {
    expect(WorldMark.of(const Creature(traitPoints: {Trait.moss: 99})), isNull);
    expect(WorldMark.of(hatched({Trait.moss: 9})), isNull);
  });

  test('die Umgebung mit den meisten Wegen zählt, in drei Stufen', () {
    expect(
      WorldMark.of(hatched({Trait.moss: 10, Trait.fins: 3})),
      const WorldMark(Trait.moss, 1),
    );
    expect(
      WorldMark.of(hatched({Trait.moss: 12, Trait.fins: 45})),
      const WorldMark(Trait.fins, 2),
    );
    expect(
      WorldMark.of(hatched({Trait.wheatEars: 300})),
      const WorldMark(Trait.wheatEars, 3),
    );
  });
}
