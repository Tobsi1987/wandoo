import 'package:geo_engine/geo_engine.dart';

/// Merkmale am Wesen, jeweils geformt von einer Umgebung.
enum Trait {
  moss(EnvironmentType.forest),
  fins(EnvironmentType.water),
  lanterns(EnvironmentType.city),
  wheatEars(EnvironmentType.field);

  const Trait(this.environment);

  final EnvironmentType environment;

  static Trait? forEnvironment(EnvironmentType type) {
    for (final trait in values) {
      if (trait.environment == type) return trait;
    }
    return null;
  }
}
