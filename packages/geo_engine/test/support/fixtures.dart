import 'dart:io';

import 'package:geo_engine/geo_engine.dart';

/// Lädt die synthetischen Testdaten aus test/fixtures/.
abstract final class Fixtures {
  static List<RoadSegment> town() =>
      RegionCodec.decode(File('test/fixtures/town.json').readAsStringSync());

  static Track gpx(String name) => GpxCodec.decode(
    File('test/fixtures/$name.gpx').readAsStringSync(),
    id: name,
  );
}
