import 'package:geo_engine/geo_engine.dart';

/// Ein Fundstück, das auf neuen Wegen liegt. Jede Umgebung hat ihr
/// eigenes; der Sternsplitter ist selten und liegt überall.
enum Find {
  acorn(EnvironmentType.forest),
  shell(EnvironmentType.water),
  sparkle(EnvironmentType.city),
  poppy(EnvironmentType.field),
  starShard(null);

  const Find(this.environment);

  /// null: kann in jeder Umgebung liegen.
  final EnvironmentType? environment;

  static Find? forEnvironment(EnvironmentType type) {
    for (final find in values) {
      if (find.environment == type) return find;
    }
    return null;
  }

  /// Belohnung aus einer Umgebung; ohne passende Umgebung ein Sternsplitter.
  static Find rewardFor(EnvironmentType? type) =>
      (type == null ? null : forEnvironment(type)) ?? starShard;
}
