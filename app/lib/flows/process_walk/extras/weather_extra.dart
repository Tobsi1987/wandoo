import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/features/world/world.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

/// Ein Gang bei Regen, Gewitter oder Schnee ist ein kleines Abenteuer:
/// Das mutige Wesen findet einen Sternsplitter.
class WeatherExtra implements WalkExtra {
  WeatherExtra({
    required this.chests,
    required this.weather,
    this.minMeters = 300,
  });

  final TreasureRepository chests;

  /// Das Wetter jetzt, also direkt nach dem Gang.
  final Weather? Function() weather;

  /// Ein paar Schritte vor die Tür zählen noch nicht.
  final int minMeters;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    final creature = outcome.after;
    final now = weather();
    final story = switch (now) {
      Weather.rain => '☔ Im Regen unterwegs',
      Weather.storm => '⛈️ Trotz Gewitter unterwegs',
      Weather.snow => '❄️ Durch den Schnee gestapft',
      _ => null,
    };
    if (story == null ||
        !creature.hatched ||
        outcome.summary.distanceMeters < minMeters) {
      return const [];
    }
    final chest = await chests.load();
    await chests.save(chest.add(const [Find.starShard]));
    final name = SpeciesCatalog.byId(creature.speciesId).name;
    return ['$story! $name war mutig: ⭐ 1 Sternsplitter'];
  }
}
