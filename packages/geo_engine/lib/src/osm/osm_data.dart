import 'package:geo_engine/src/model/geo_point.dart';

/// Ein OSM-Weg, der begehbar ist (Straße, Fußweg, Pfad).
class OsmRoad {
  const OsmRoad({
    required this.id,
    required this.nodeIds,
    required this.points,
    required this.tags,
  });

  final int id;
  final List<int> nodeIds;
  final List<GeoPoint> points;
  final Map<String, String> tags;
}

/// Eine Fläche (Wald, Wasser, Wohngebiet) aus äußeren und inneren Ringen.
class OsmArea {
  const OsmArea({required this.outer, required this.inner, required this.tags});

  final List<List<GeoPoint>> outer;
  final List<List<GeoPoint>> inner;
  final Map<String, String> tags;
}

/// Ein Gewässer als Linie (Fluss, Bach, Kanal).
class OsmWaterLine {
  const OsmWaterLine({required this.points, required this.tags});

  final List<GeoPoint> points;
  final Map<String, String> tags;
}

/// Alles, was aus einer Overpass-Antwort für Wandoo gebraucht wird.
class OsmData {
  const OsmData({
    required this.roads,
    required this.areas,
    required this.waterLines,
  });

  final List<OsmRoad> roads;
  final List<OsmArea> areas;
  final List<OsmWaterLine> waterLines;
}
