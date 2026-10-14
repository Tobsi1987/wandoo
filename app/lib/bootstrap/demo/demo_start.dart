import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/bootstrap/demo/demo_params.dart';
import 'package:wandoo/bootstrap/demo/demo_town.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/hunger/hunger.dart';
import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/world/world.dart';

// Wie die Demo startet, gesteuert über die Adresse (siehe `demoParams`).

/// `?wetter=regen` (oder `schnee`, `gewitter`, `sonne`) stellt das Wetter.
Weather? demoWeather() => switch (demoParams['wetter']) {
  'regen' => Weather.rain,
  'schnee' => Weather.snow,
  'gewitter' => Weather.storm,
  'sonne' => Weather.clear,
  _ => null,
};

class FixedWeather implements WeatherSource {
  const FixedWeather(this.weather);
  final Weather weather;
  @override
  Future<Weather?> current(GeoPoint place) async => weather;
}

/// `?hunger=leer` startet mit leerem Bauch, `?hunger=weg` so, dass das
/// Wesen gleich auszieht (mit `?wesen=…`).
Belly? demoBelly() {
  final hungry = switch (demoParams['hunger']) {
    'leer' => const Duration(hours: 2),
    'weg' => Belly.leavesAfter + const Duration(minutes: 1),
    _ => null,
  };
  if (hungry == null) return null;
  return Belly(
    lineKey: demoCreature().lineKey,
    meters: 0,
    at: DateTime.now().subtract(hungry),
  );
}

/// `?level=9` startet kurz vor dem nächsten Level (mit `?wesen=…`).
Progress? demoProgress() {
  final level = int.tryParse(demoParams['level'] ?? '');
  if (level == null) return null;
  return Progress(
    lineKey: demoCreature().lineKey,
    xp: LevelCurve.xpFor(level + 1) - 15,
  );
}

/// `?uhr=8` zeigt die Welt um 8 Uhr, egal wie spät es ist.
int? demoHour() => int.tryParse(demoParams['uhr'] ?? '');

class DemoMapData implements MapDataSource {
  @override
  Future<List<RoadSegment>> segmentsNear(List<GeoPoint> points) async =>
      DemoTown.segments;
}

/// Was in der Demo aus dem Ei schlüpft: `?ei=funkel`, sonst ein Zufallswesen
/// wie in der App.
String? demoHatches() => demoParams['ei'];

/// `?wesen=funkel` startet die Demo mit diesem Wesen geschlüpft und allen
/// Arten im Album, um die 3D-Modelle anzusehen. Ohne Angabe: ein Ei, das
/// schon nach dem ersten Gang schlüpft.
Creature demoCreature() {
  final query = demoParams;
  final id = query['wesen'];
  if (id == null) return const Creature(food: 16);
  return Creature(
    food: GrowthStage.adult.foodNeeded,
    speciesId: SpeciesCatalog.byId(id).id,
    seenSpecies: {for (final s in SpeciesCatalog.all) s.id},
    hat: _named(CreatureHat.values, query['hut']),
    neck: _named(CreatureNeck.values, query['hals']),
  );
}

T? _named<T extends Enum>(List<T> values, String? name) =>
    values.where((v) => v.name == name).firstOrNull;
