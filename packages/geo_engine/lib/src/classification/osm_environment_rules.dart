import 'package:geo_engine/src/model/environment_type.dart';

/// Zuordnungstabelle OSM-Tag zu Umgebungstyp.
///
/// Reihenfolge zählt: Die erste passende Regel gewinnt. Ein Wert `*`
/// passt auf jeden Wert des Schlüssels.
const List<(String key, String value, EnvironmentType type)>
osmEnvironmentRules = [
  ('natural', 'water', EnvironmentType.water),
  ('waterway', '*', EnvironmentType.water),
  ('landuse', 'reservoir', EnvironmentType.water),
  ('landuse', 'forest', EnvironmentType.forest),
  ('natural', 'wood', EnvironmentType.forest),
  ('landuse', 'farmland', EnvironmentType.field),
  ('landuse', 'meadow', EnvironmentType.field),
  ('landuse', 'grass', EnvironmentType.field),
  ('landuse', 'residential', EnvironmentType.city),
  ('landuse', 'commercial', EnvironmentType.city),
  ('landuse', 'retail', EnvironmentType.city),
  ('place', 'square', EnvironmentType.city),
];
