import 'dart:convert';
import 'dart:io';

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/world/domain/weather.dart';
import 'package:wandoo/features/world/domain/weather_source.dart';

/// Holt das aktuelle Wetter von Open-Meteo (frei, ohne Schlüssel).
///
/// Gesendet wird nur ein grober Ort, auf 0,1 Grad gerundet (rund 10 km).
class OpenMeteoWeatherSource implements WeatherSource {
  OpenMeteoWeatherSource({HttpClient? http}) : _http = http ?? HttpClient();

  final HttpClient _http;

  @override
  Future<Weather?> current(GeoPoint place) async {
    try {
      final request = await _http.getUrl(uri(place));
      final response = await request.close().timeout(
        const Duration(seconds: 8),
      );
      if (response.statusCode != HttpStatus.ok) return null;
      return parse(await response.transform(utf8.decoder).join());
    } on Object {
      return null;
    }
  }

  static Uri uri(GeoPoint place) =>
      Uri.https('api.open-meteo.com', '/v1/forecast', {
        'latitude': place.latitude.toStringAsFixed(1),
        'longitude': place.longitude.toStringAsFixed(1),
        'current': 'weather_code',
      });

  /// Liest den Wettercode aus der Antwort; null, wenn er fehlt.
  static Weather? parse(String body) {
    final json = jsonDecode(body);
    if (json is! Map<String, dynamic>) return null;
    final current = json['current'];
    if (current is! Map<String, dynamic>) return null;
    final code = current['weather_code'];
    return code is int ? Weather.fromWmo(code) : null;
  }
}
