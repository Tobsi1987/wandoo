/// Wie eine Tierart dargestellt wird.
///
/// Bis echte 3D-Modelle da sind, zeichnet der Shader eine von vier
/// Platzhalter-Figuren. Liegt ein Modell vor, kommt sein Pfad in
/// [modelAsset]; `CreatureFigure` zeigt dann das Modell.
class SpeciesLook {
  const SpeciesLook({required this.placeholder, this.modelAsset});

  /// Platzhalter im Shader: 0 Bär, 1 Axolotl, 2 Waschbär, 3 Häschen.
  final int placeholder;

  /// z. B. `assets/creatures/axolotl.glb`; null, solange es keins gibt.
  final String? modelAsset;
}

/// Aussehen je `Species.id`. Jede Art im `SpeciesCatalog` braucht hier
/// einen Eintrag (ein Test prüft das).
const Map<String, SpeciesLook> speciesLooks = {
  'aehrenhase': SpeciesLook(placeholder: 3),
  'moosbaer': SpeciesLook(placeholder: 0),
  'axolotl': SpeciesLook(placeholder: 1),
  'waschbaer': SpeciesLook(placeholder: 2),
};
