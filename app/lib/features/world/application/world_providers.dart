import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/core/location/location_providers.dart';
import 'package:wandoo/features/world/domain/weather.dart';
import 'package:wandoo/features/world/domain/weather_source.dart';
import 'package:wandoo/features/world/domain/world_state.dart';

/// Wird im Bootstrap gesetzt. Ohne Quelle gibt es einfach kein Wetter.
final weatherSourceProvider = Provider<WeatherSource?>((ref) => null);

/// Uhr der Welt; in Tests und der Demo überschreibbar.
final worldClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Tickt jede Minute, damit Nacht und Jahreszeit von selbst wechseln.
final _minuteProvider = StreamProvider<DateTime>((ref) async* {
  final now = ref.watch(worldClockProvider);
  yield now();
  yield* Stream.periodic(const Duration(minutes: 1), (_) => now());
});

/// Alle 15 Minuten neu nach dem Wetter fragen.
final _quarterProvider = StreamProvider<int>(
  (ref) => Stream.periodic(const Duration(minutes: 15), (i) => i + 1),
);

final _weatherProvider = FutureProvider<Weather?>((ref) async {
  final source = ref.watch(weatherSourceProvider);
  if (source == null) return null;
  ref.watch(_quarterProvider);
  final place = await ref.watch(locationSourceProvider).currentPosition();
  return place == null ? null : await source.current(place);
});

/// Wie die Welt gerade ist. Fehlt das Wetter, ist es einfach unbekannt.
final worldStateProvider = Provider<WorldState>((ref) {
  final now =
      ref.watch(_minuteProvider).value ?? ref.watch(worldClockProvider)();
  return WorldState.at(now, weather: ref.watch(_weatherProvider).value);
});
