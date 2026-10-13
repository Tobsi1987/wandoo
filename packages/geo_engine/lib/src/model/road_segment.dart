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
    String? streetId,
  }) : streetId = streetId ?? id;

  final String id;
  final GeoPoint start;
  final GeoPoint end;
  final Map<String, String> areaTags;

  /// Straße, zu der der Abschnitt gehört (Name oder OSM-Weg). Damit zählt
  /// "+3 neue Straßen" Straßen statt einzelner Stücke.
  final String streetId;

  double get lengthMeters => start.distanceTo(end);
}
