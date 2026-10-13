// Erzeugt die synthetischen Testdaten unter test/fixtures/.
// Aufruf aus packages/geo_engine: dart run tool/generate_fixtures.dart
import 'dart:io';

import 'package:geo_engine/geo_engine.dart';

import 'synthetic_town.dart';

void main() {
  const n = SyntheticTown.node;
  _write('town.json', RegionCodec.encode(SyntheticTown.segments()));
  _gpx(walk('main_street', [n(0, 2), n(4, 2)]));
  _gpx(
    walk(
      'sparse_turn',
      [n(0, 0), n(2, 0), n(2, 2)],
      intervalSeconds: 30,
      noiseMeters: 6,
      seed: 2,
    ),
  );
  _gpx(walk('drive_through', [n(0, 0), n(4, 0)], speedKmh: 50, seed: 3));
  _gpx(
    walk(
      'forest_loop',
      [n(3, 1), n(4, 1), n(4, 3), n(3, 3), n(3, 1)],
      noiseMeters: 8,
      seed: 4,
    ),
  );
  stdout.writeln('Fixtures geschrieben.');
}

void _gpx(Track track) => _write('${track.id}.gpx', GpxCodec.encode(track));

void _write(String name, String content) =>
    File('test/fixtures/$name').writeAsStringSync(content);
