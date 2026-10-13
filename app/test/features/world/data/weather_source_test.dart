import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/world/data/cached_weather_source.dart';
import 'package:wandoo/features/world/data/open_meteo_weather_source.dart';
import 'package:wandoo/features/world/world.dart';

class _Counting implements WeatherSource {
  int calls = 0;
  Weather? next = Weather.rain;

  @override
  Future<Weather?> current(GeoPoint place) async {
    calls++;
    return next;
  }
}

void main() {
  test('Open-Meteo bekommt nur einen groben Ort', () {
    final uri = OpenMeteoWeatherSource.uri(const GeoPoint(50.1234, 8.6789));
    expect(uri.host, 'api.open-meteo.com');
    expect(uri.queryParameters['latitude'], '50.1');
    expect(uri.queryParameters['longitude'], '8.7');
  });

  test('liest den Wettercode', () {
    expect(
      OpenMeteoWeatherSource.parse('{"current":{"weather_code":63}}'),
      Weather.rain,
    );
    expect(OpenMeteoWeatherSource.parse('{"current":{}}'), isNull);
    expect(OpenMeteoWeatherSource.parse('[]'), isNull);
  });

  test(
    'fragt höchstens alle 30 Minuten, behält altes Wetter offline',
    () async {
      final inner = _Counting();
      var now = DateTime(2026, 10, 14, 9);
      final cached = CachedWeatherSource(inner, clock: () => now);
      const here = GeoPoint(50, 8);
      expect(await cached.current(here), Weather.rain);
      now = now.add(const Duration(minutes: 10));
      await cached.current(here);
      expect(inner.calls, 1);
      now = now.add(const Duration(minutes: 30));
      inner.next = null;
      expect(await cached.current(here), Weather.rain);
      expect(inner.calls, 2);
    },
  );
}
