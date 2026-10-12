import 'package:geo_engine/src/model/geo_point.dart';

/// Ein Straßenabschnitt aus OpenStreetMap zwischen zwei Knoten.
///
/// [areaTags] sind die OSM-Tags der Fläche, in der der Abschnitt liegt
/// (zum Beispiel `landuse=forest`). Sie werden bei der Aufbereitung der
/// Regionsdaten angehängt, siehe `tool/osm_pipeline/`.
class RoadSegment {
  const RoadSegment({
    required this.id,
    required this.start,
    required this.end,
    this.areaTags = const {},
  });

  final String id;
  final GeoPoint start;
  final GeoPoint end;
  final Map<String, String> areaTags;

  double get lengthMeters => start.distanceTo(end);
}
