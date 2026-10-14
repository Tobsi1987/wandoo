import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/hunger/data/in_memory_belly_repository.dart';
import 'package:wandoo/features/hunger/hunger.dart';
import 'package:wandoo/features/reminders/reminders.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/flows/hunger/check_hunger.dart';
import 'package:wandoo/flows/process_walk/extras/hunger_extra.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

final _start = DateTime(2026, 10, 14, 12);
const _moosel = Creature(
  food: 30,
  speciesId: 'moosel',
  seenSpecies: {'moosel'},
);

WalkOutcome _walk(int meters) => WalkOutcome(
  track: const Track(id: 'w', points: []),
  summary: WalkSummary(
    walkId: 'w',
    finishedAt: _start,
    newSegmentCount: 0,
    newStreetCount: 0,
    streetsByEnvironment: const {},
    bridgeCount: 0,
    creatureGrew: false,
    distanceMeters: meters,
  ),
  newSegmentsByEnvironment: const {},
  after: _moosel,
);

void main() {
  test('frisch geschlüpft: voller Bauch, kein Auszug', () async {
    final bellies = InMemoryBellyRepository();
    final check = CheckHunger(
      creatures: InMemoryCreatureRepository(_moosel),
      bellies: bellies,
      clock: () => _start,
    );
    expect(await check(), isNull);
    expect((await bellies.load())?.fillAt(_start), 1);
  });

  test('zwei Tage leer: Brief, neues Ei, Album bleibt', () async {
    final creatures = InMemoryCreatureRepository(_moosel);
    final bellies = InMemoryBellyRepository(
      Belly(lineKey: _moosel.lineKey, meters: 0, at: _start),
    );
    final check = CheckHunger(
      creatures: creatures,
      bellies: bellies,
      clock: () => _start.add(const Duration(days: 2)),
    );
    final letter = await check();
    expect(letter?.speciesId, 'moosel');
    expect(bellies.letter?.speciesId, 'moosel');
    final egg = await creatures.load();
    expect(egg.hatched, isFalse);
    expect(egg.seenSpecies, {'moosel'});
    expect(egg.lineKey, isNot(_moosel.lineKey));
  });

  test('Gehen füllt den Bauch und sagt es', () async {
    final bellies = InMemoryBellyRepository(
      Belly(lineKey: _moosel.lineKey, meters: 1000, at: _start),
    );
    final extra = HungerExtra(bellies, clock: () => _start);
    expect(await extra.onWalk(_walk(1500)), [
      '🍎 Moosel hat gegessen: Bauch zu 50 % voll',
    ]);
    expect(await extra.onWalk(_walk(4000)), ['🍎 Moosel ist pappsatt!']);
    expect(await extra.onWalk(_walk(500)), isEmpty);
  });

  test('ab dem leeren Bauch dringliche Erinnerungen', () {
    final plan = const PlanReminder()(
      _start,
      name: 'Moosel',
      hungryAt: _start.add(const Duration(days: 2, hours: 2)),
    );
    expect(plan.map((r) => (r.at.day, r.title)), [
      (15, 'Moosel möchte raus'),
      (16, 'Moosel hat Hunger'),
      (17, 'Moosel ist ganz traurig'),
    ]);
  });
}
