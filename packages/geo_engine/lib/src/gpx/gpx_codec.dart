import 'package:geo_engine/src/model/geo_point.dart';
import 'package:geo_engine/src/model/track.dart';
import 'package:geo_engine/src/model/track_point.dart';

/// Liest und schreibt GPX-Spuren (Version 1.1, nur Trackpunkte mit Zeit).
///
/// Bewusst ohne XML-Bibliothek: GPX-Trackpunkte sind einfach genug für
/// reguläre Ausdrücke, und `geo_engine` bleibt ohne Abhängigkeiten.
abstract final class GpxCodec {
  static final _trkpt = RegExp(r'<trkpt\b([^>]*)>(.*?)</trkpt>', dotAll: true);
  static final _lat = RegExp('''lat=["']([^"']+)["']''');
  static final _lon = RegExp('''lon=["']([^"']+)["']''');
  static final _time = RegExp('<time>([^<]+)</time>');

  static Track decode(String gpx, {required String id}) {
    final points = <TrackPoint>[];
    for (final match in _trkpt.allMatches(gpx)) {
      final attributes = match.group(1)!;
      final lat = _lat.firstMatch(attributes)?.group(1);
      final lon = _lon.firstMatch(attributes)?.group(1);
      final time = _time.firstMatch(match.group(2)!)?.group(1);
      if (lat == null || lon == null || time == null) {
        throw FormatException('Trackpunkt ohne lat, lon oder time', match[0]);
      }
      points.add(
        TrackPoint(
          GeoPoint(double.parse(lat), double.parse(lon)),
          DateTime.parse(time.trim()),
        ),
      );
    }
    return Track(id: id, points: points);
  }

  static String encode(Track track) {
    final buffer = StringBuffer()
      ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
      ..writeln('<gpx version="1.1" creator="wandoo">')
      ..writeln('  <trk><name>${track.id}</name><trkseg>');
    for (final p in track.points) {
      final lat = p.position.latitude.toStringAsFixed(7);
      final lon = p.position.longitude.toStringAsFixed(7);
      final time = p.time.toUtc().toIso8601String();
      buffer.writeln(
        '    <trkpt lat="$lat" lon="$lon"><time>$time</time></trkpt>',
      );
    }
    buffer.writeln('  </trkseg></trk>\n</gpx>');
    return buffer.toString();
  }
}
