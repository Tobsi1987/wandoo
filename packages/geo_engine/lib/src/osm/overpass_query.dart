/// Baut die Overpass-Abfrage für ein Rechteck (Süd, West, Nord, Ost).
///
/// Geholt werden begehbare Wege, Flächen für die Umgebung und
/// Gewässerlinien, jeweils mit Geometrie (`out geom`).
String overpassQuery(double south, double west, double north, double east) {
  final bbox = '$south,$west,$north,$east';
  const walkable =
      'footway|path|pedestrian|living_street|residential|service|track|'
      'unclassified|tertiary|secondary|primary|steps|cycleway|bridleway';
  return '[out:json][timeout:90];('
      'way["highway"~"^($walkable)\$"]($bbox);'
      'way["landuse"]($bbox);'
      'relation["landuse"]($bbox);'
      'way["natural"~"^(water|wood)\$"]($bbox);'
      'relation["natural"~"^(water|wood)\$"]($bbox);'
      'way["leisure"="park"]($bbox);'
      'way["waterway"~"^(river|stream|canal)\$"]($bbox);'
      ');out geom;';
}
