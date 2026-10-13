import 'package:wandoo/features/world/domain/daytime.dart';
import 'package:wandoo/features/world/domain/weather.dart';
import 'package:wandoo/features/world/domain/world_state.dart';

/// Ein kurzer Satz zur Welt für den Startbildschirm, oder null.
String? worldLine(WorldState w) {
  if (w.weather == Weather.storm) {
    return 'Gewitter! Heute lieber drinnen bleiben.';
  }
  if (w.night) return 'Psst, dein Wesen schläft. Gute Nacht!';
  return switch (w.weather) {
    Weather.rain => 'Es regnet. Zeit für Gummistiefel und Pfützen!',
    Weather.snow => 'Es schneit! Deine Spuren sind heute ganz frisch.',
    Weather.fog => 'Nebel! Bleib heute nah bei deinen Großen.',
    Weather.clear when w.daytime == Daytime.morning =>
      'Guten Morgen! Die Sonne scheint.',
    _ => null,
  };
}
