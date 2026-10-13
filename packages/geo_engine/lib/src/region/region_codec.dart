import 'dart:convert';

import 'package:geo_engine/src/model/geo_point.dart';
import 'package:geo_engine/src/model/road_segment.dart';

/// Kompaktes JSON-Format für Regionsdaten auf dem Gerät.
///
/// `{"v":1,"segments":[[id, lat1, lon1, lat2, lon2, {tags}, streetId]]}`
abstract final class RegionCodec {
  static const version = 1;

  static String encode(List<RoadSegment> segments) => jsonEncode({
    'v': version,
    'segments': [
      for (final s in segments)
        [
          s.id,
          s.start.latitude,
          s.start.longitude,
          s.end.latitude,
          s.end.longitude,
          s.areaTags,
          s.streetId,
        ],
    ],
  });

  static List<RoadSegment> decode(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    if (data['v'] != version) {
      throw FormatException('Unbekannte Regionsversion ${data['v']}');
    }
    return [
      for (final row in data['segments'] as List<dynamic>)
        _segment(row as List),
    ];
  }

  static RoadSegment _segment(List<dynamic> row) {
    double n(int i) => (row[i] as num).toDouble();
    return RoadSegment(
      id: row[0] as String,
      start: GeoPoint(n(1), n(2)),
      end: GeoPoint(n(3), n(4)),
      areaTags: (row[5] as Map<String, dynamic>).cast<String, String>(),
      streetId: row.length > 6 ? row[6] as String : null,
    );
  }
}
