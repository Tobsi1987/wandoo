/// Wie eine Tierart dargestellt wird.
///
/// Liegt ein 3D-Modell vor, steht sein Pfad in [modelAsset] und
/// `CreatureFigure` zeigt das Modell. Sonst (und als Ei, Umriss oder
/// solange das Modell lädt) zeichnet der Shader eine von vier
/// Platzhalter-Figuren.
class SpeciesLook {
  const SpeciesLook({required this.placeholder, this.modelAsset});

  /// Platzhalter im Shader: 0 Bär, 1 Axolotl, 2 Waschbär, 3 Häschen.
  final int placeholder;

  /// z. B. `assets/creatures/funkel.glb`; null, solange es keins gibt.
  /// Modelle kommen aus Meshy und werden mit `tool/prepare_model.mjs`
  /// verkleinert: Füße auf y = 0, genau 1 Einheit hoch, Blick nach vorn.
  final String? modelAsset;
}

SpeciesLook _model(String id, int placeholder) => SpeciesLook(
  placeholder: placeholder,
  modelAsset: 'assets/creatures/$id.glb',
);

/// Aussehen je `Species.id`. Jede Art im `SpeciesCatalog` braucht hier
/// einen Eintrag (ein Test prüft das).
final Map<String, SpeciesLook> speciesLooks = {
  'funkel': _model('funkel', 0),
  'moosel': _model('moosel', 0),
  'pfuetzling': _model('pfuetzling', 1),
  'kieselchen': _model('kieselchen', 3),
  'pustel': const SpeciesLook(placeholder: 3),
  'schnirp': _model('schnirp', 2),
  'brummli': _model('brummli', 0),
  'zapfi': _model('zapfi', 2),
  'laternchen': _model('laternchen', 2),
  'wolkenwuff': _model('wolkenwuff', 0),
  'blitzmaus': _model('blitzmaus', 3),
  'blaetterdrache': _model('blaetterdrache', 1),
  'pilzling': _model('pilzling', 0),
  'kristallis': _model('kristallis', 1),
  'fluffeule': const SpeciesLook(placeholder: 3),
  'nebelfuchs': _model('nebelfuchs', 2),
  'glutling': _model('glutling', 1),
  'wellenwal': _model('wellenwal', 1),
  'aurora': _model('aurora', 2),
  'sternschnuppe': _model('sternschnuppe', 3),
};
