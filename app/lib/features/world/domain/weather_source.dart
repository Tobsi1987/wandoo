import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/world/domain/weather.dart';

/// Liefert das aktuelle Wetter an einem Ort.
abstract interface class WeatherSource {
  /// Null, wenn es gerade nicht zu ermitteln ist (offline, Fehler).
  Future<Weather?> current(GeoPoint place);
}
