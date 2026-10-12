import 'package:geo_engine/geo_engine.dart';

/// Liefert Straßenabschnitte aus den OSM-Regionsdaten auf dem Gerät.
abstract interface class MapDataSource {
  /// Alle Abschnitte in der Nähe der übergebenen Punkte.
  Future<List<RoadSegment>> segmentsNear(List<GeoPoint> points);
}
