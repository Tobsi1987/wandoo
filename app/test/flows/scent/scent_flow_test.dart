import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/discovery/data/in_memory_known_segments_repository.dart';
import 'package:wandoo/features/environment/environment.dart';
import 'package:wandoo/features/scent/data/in_memory_scent_repository.dart';
import 'package:wandoo/features/scent/scent.dart';
import 'package:wandoo/features/treasure/data/in_memory_treasure_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/flows/process_walk/extras/scent_extra.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';
import 'package:wandoo/flows/scent/sniff_out.dart';

GeoPoint at(double north, double east) =>
    GeoPoint(52 + north / 111195, 7 + east / (111195 * cos(52 * pi / 180)));

RoadSegment road(String id, double north) =>
    RoadSegment(id: id, start: at(north, -20), end: at(north, 20));

class _Map implements MapDataSource {
  _Map(this.segments);
  final List<RoadSegment> segments;
  @override
  Future<List<RoadSegment>> segmentsNear(List<GeoPoint> points) async =>
      segments;
}

void main() {
  final now = DateTime(2026, 10, 14, 9);
  late InMemoryScentRepository scents;
  late InMemoryKnownSegmentsRepository known;
  late SniffOut sniff;

  setUp(() {
    scents = InMemoryScentRepository();
    known = InMemoryKnownSegmentsRepository();
    sniff = SniffOut(
      mapData: _Map([road('nah', 30), road('a', 250), road('b', 300)]),
      known: known,
      classify: const ClassifySegments(),
      scents: scents,
      random: Random(3),
    );
  });

  test('riecht nur unbekannte Straßen und bleibt bei seiner Spur', () async {
    await known.addAll({'a'});
    final first = await sniff(at(0, 0), now);
    expect(first!.target.distanceTo(at(300, 0)), lessThan(1));
    // Am nächsten Tag ist es noch dieselbe Spur.
    final again = await sniff(at(10, 0), now.add(const Duration(days: 1)));
    expect(again!.createdAt, now);
  });

  test('alte oder weit entfernte Spuren werden neu gerochen', () async {
    await sniff(at(0, 0), now);
    final later = now.add(const Duration(days: 4));
    expect((await sniff(at(0, 0), later))!.createdAt, later);
  });

  group('ScentExtra', () {
    const hatched = Creature(food: 20, speciesId: 'moosel');
    WalkOutcome walk(List<GeoPoint> points, {Creature c = hatched}) =>
        WalkOutcome(
          track: Track(
            id: 'w',
            points: [for (final p in points) TrackPoint(p, now)],
          ),
          summary: WalkSummary(
            walkId: 'w',
            finishedAt: now,
            newSegmentCount: 0,
            newStreetCount: 0,
            streetsByEnvironment: const {},
            bridgeCount: 0,
            creatureGrew: false,
          ),
          newSegmentsByEnvironment: const {},
          after: c,
        );

    test('am Fund vorbei: zwei Fundstücke, danach eine neue Spur', () async {
      final chests = InMemoryTreasureRepository();
      await scents.save(
        Scent(
          target: at(100, 0),
          environment: EnvironmentType.forest,
          createdAt: now,
        ),
      );
      final extra = ScentExtra(scents: scents, chests: chests, sniff: sniff);
      final lines = await extra.onWalk(walk([at(0, 0), at(100, 5)]));
      expect(lines, ['👃 Moosel hat erschnüffelt: 🌰 2 Eicheln']);
      expect((await chests.load()).count(Find.acorn), 2);
      final next = await scents.load();
      expect(next, isNotNull);
      expect(next!.target.distanceTo(at(100, 0)), greaterThan(1));
    });

    test('nicht vorbeigekommen oder noch ein Ei: nichts', () async {
      final chests = InMemoryTreasureRepository();
      final scent = Scent(target: at(250, 0), createdAt: now);
      await scents.save(scent);
      final extra = ScentExtra(scents: scents, chests: chests, sniff: sniff);
      expect(await extra.onWalk(walk([at(0, 0), at(50, 0)])), isEmpty);
      final egg = walk([at(0, 0), at(250, 0)], c: const Creature(food: 5));
      expect(await extra.onWalk(egg), isEmpty);
      expect((await chests.load()).finds, isEmpty);
      expect((await scents.load())!.target, scent.target);
    });
  });
}
