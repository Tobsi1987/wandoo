import 'package:geo_engine/src/model/road_segment.dart';
import 'package:geo_engine/src/model/track.dart';

/// Ordnet eine GPS-Spur den Straßenabschnitten zu, die tatsächlich
/// begangen wurden.
///
/// Das ist laut Konzept der technisch kniffligste Teil. Die Schnittstelle
/// erlaubt, die einfache Umsetzung später gegen eine bessere zu tauschen,
/// ohne dass sich die App ändert.
abstract interface class MapMatcher {
  /// Liefert die IDs aller begangenen Abschnitte aus [candidates].
  Set<String> match(Track track, List<RoadSegment> candidates);
}
