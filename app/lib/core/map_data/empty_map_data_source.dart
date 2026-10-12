import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';

/// Platzhalter ohne Kartendaten, bis die Regionspakete stehen.
class EmptyMapDataSource implements MapDataSource {
  const EmptyMapDataSource();

  @override
  Future<List<RoadSegment>> segmentsNear(List<GeoPoint> points) async =>
      const [];
}
