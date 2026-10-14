import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/treasure/data/in_memory_treasure_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/features/world/world.dart';
import 'package:wandoo/flows/process_walk/extras/weather_extra.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

WalkOutcome _walk(int meters, {Creature after = _moosel}) {
  final at = DateTime(2026, 10, 14, 15);
  return WalkOutcome(
    track: Track(id: 'w', points: [TrackPoint(const GeoPoint(52, 7), at)]),
    summary: WalkSummary(
      walkId: 'w',
      finishedAt: at,
      newSegmentCount: 0,
      newStreetCount: 0,
      streetsByEnvironment: const {},
      bridgeCount: 0,
      creatureGrew: false,
      distanceMeters: meters,
    ),
    newSegmentsByEnvironment: const {},
    after: after,
  );
}

const _moosel = Creature(food: 20, speciesId: 'moosel');

void main() {
  test('Regen-Gang: Sternsplitter fürs mutige Wesen', () async {
    final chests = InMemoryTreasureRepository();
    final extra = WeatherExtra(chests: chests, weather: () => Weather.rain);
    expect(await extra.onWalk(_walk(800)), [
      '☔ Im Regen unterwegs! Moosel war mutig: ⭐ 1 Sternsplitter',
    ]);
    expect((await chests.load()).count(Find.starShard), 1);
  });

  test('Sonne, kurze Gänge und Eier bekommen nichts', () async {
    final chests = InMemoryTreasureRepository();
    expect(
      await WeatherExtra(
        chests: chests,
        weather: () => Weather.clear,
      ).onWalk(_walk(800)),
      isEmpty,
    );
    final snow = WeatherExtra(chests: chests, weather: () => Weather.snow);
    expect(await snow.onWalk(_walk(100)), isEmpty);
    expect(
      await snow.onWalk(_walk(800, after: const Creature(food: 3))),
      isEmpty,
    );
    expect((await chests.load()).finds, isEmpty);
  });
}
