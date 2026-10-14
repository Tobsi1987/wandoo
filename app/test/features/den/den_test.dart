import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/drift_den_repository.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/creature/data/in_memory_den_repository.dart';
import 'package:wandoo/features/den/den.dart';
import 'package:wandoo/features/hunger/data/in_memory_belly_repository.dart';
import 'package:wandoo/features/hunger/hunger.dart';

import '../../support/test_database.dart';

final _start = DateTime(2026, 10, 14, 12);
final _moosel = Creature(
  food: 120,
  speciesId: 'moosel',
  seenSpecies: const {'moosel'},
  traitPoints: const {Trait.moss: 4},
  hat: CreatureHat.acornCap,
  lastFedAt: _start,
  walkedMeters: 30000,
);

void main() {
  test(
    'zweites Ei, Tausch, und im Schlaf wird der Bauch nicht leerer',
    () async {
      var now = _start;
      final creatures = InMemoryCreatureRepository(_moosel);
      final den = InMemoryDenRepository();
      final bellies = InMemoryBellyRepository([
        Belly(lineKey: _moosel.lineKey, meters: 3000, at: _start),
      ]);
      final swap = SwapCreatures(
        creatures: creatures,
        den: den,
        bellies: bellies,
        clock: () => now,
      );
      await swap.takeSecondEgg();
      final egg = await creatures.load();
      expect(egg.hatched, isFalse);
      expect(egg.seenSpecies, {'moosel'});
      expect((await den.load())?.creature.speciesId, 'moosel');

      now = _start.add(const Duration(days: 10));
      await creatures.save(
        egg.copyWith(
          food: 30,
          speciesId: 'funkel',
          seenSpecies: {'moosel', 'funkel'},
        ),
      );
      await swap.swap();
      final woken = await creatures.load();
      expect(woken.speciesId, 'moosel');
      expect(woken.hat, CreatureHat.acornCap);
      expect(woken.seenSpecies, {'moosel', 'funkel'});
      expect((await bellies.load(woken.lineKey))?.metersAt(now), 3000);
      expect((await den.load())?.creature.speciesId, 'funkel');
    },
  );

  test('Datenbank merkt sich das schlafende Wesen ganz', () async {
    final repo = DriftDenRepository(testDatabase());
    expect(await repo.load(), isNull);
    await repo.save(Sleeper(creature: _moosel, since: _start));
    final back = (await repo.load())!;
    expect(back.since, _start);
    expect(back.creature.speciesId, 'moosel');
    expect(back.creature.traitPoints, {Trait.moss: 4});
    expect(back.creature.hat, CreatureHat.acornCap);
    expect(back.creature.lastFedAt, _start);
    expect(back.creature.walkedMeters, 30000);
    expect(back.creature.lineKey, _moosel.lineKey);
  });
}
