import 'package:meta/meta.dart';
import 'package:wandoo/features/world/domain/daytime.dart';
import 'package:wandoo/features/world/domain/egg_theme.dart';
import 'package:wandoo/features/world/domain/weather.dart';

/// Wie die Welt gerade ist: Tageszeit, Wetter, Jahreszeit.
@immutable
class WorldState {
  const WorldState({
    required this.daytime,
    required this.eggTheme,
    this.weather,
  });

  WorldState.at(DateTime local, {Weather? weather})
    : this(
        daytime: Daytime.at(local),
        eggTheme: EggTheme.on(local),
        weather: weather,
      );

  final Daytime daytime;
  final EggTheme eggTheme;

  /// Null, solange das Wetter unbekannt ist.
  final Weather? weather;

  bool get night => daytime == Daytime.night;

  @override
  bool operator ==(Object other) =>
      other is WorldState &&
      other.daytime == daytime &&
      other.eggTheme == eggTheme &&
      other.weather == weather;

  @override
  int get hashCode => Object.hash(daytime, eggTheme, weather);
}
