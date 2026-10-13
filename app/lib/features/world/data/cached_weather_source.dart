import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/world/domain/weather.dart';
import 'package:wandoo/features/world/domain/weather_source.dart';

/// Fragt höchstens alle [maxAge] neu, damit die App nicht ständig ins Netz
/// geht.
class CachedWeatherSource implements WeatherSource {
  CachedWeatherSource(
    this._inner, {
    this.maxAge = const Duration(minutes: 30),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final WeatherSource _inner;
  final Duration maxAge;
  final DateTime Function() _clock;
  Weather? _last;
  DateTime? _at;

  @override
  Future<Weather?> current(GeoPoint place) async {
    final now = _clock();
    final at = _at;
    if (_last != null && at != null && now.difference(at) < maxAge) {
      return _last;
    }
    final fresh = await _inner.current(place);
    if (fresh != null) {
      _last = fresh;
      _at = now;
    }
    return fresh ?? _last;
  }
}
