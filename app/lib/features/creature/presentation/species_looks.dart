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
  /// Modelle sind Meshy-Rigs, die `tool/animate_rig.mjs` animiert und
  /// zurechtrückt: Füße auf y = 0, in einer 1×1-Box, Blick nach vorn.
  final String? modelAsset;
}

SpeciesLook _model(String id, int placeholder) =>
    SpeciesLook(placeholder: placeholder, modelAsset: modelAssetOf(id));

/// Pfad des Modells mit der Id [id], z. B. `funkel2`.
String modelAssetOf(String id) => 'assets/creatures/$id.glb';

/// Aussehen je `Species.id`. Jede Art im `SpeciesCatalog` braucht hier
/// einen Eintrag (ein Test prüft das).
final Map<String, SpeciesLook> speciesLooks = {
  'funkel': _model('funkel', 0),
  'moosel': _model('moosel', 0),
  'pfuetzling': _model('pfuetzling', 1),
  'kieselchen': _model('kieselchen', 3),
  'pustel': _model('pustel', 3),
  'schnirp': _model('schnirp', 2),
  'brummli': _model('brummli', 0),
  'zapfi': _model('zapfi', 2),
  'laternchen': _model('laternchen', 2),
  'wolkenwuff': _model('wolkenwuff', 0),
  'blitzmaus': _model('blitzmaus', 3),
  'blaetterdrache': _model('blaetterdrache', 1),
  'pilzling': _model('pilzling', 0),
  'kristallis': _model('kristallis', 1),
  'fluffeule': _model('fluffeule', 3),
  'nebelfuchs': _model('nebelfuchs', 2),
  'glutling': _model('glutling', 1),
  'wellenwal': _model('wellenwal', 1),
  'aurora': _model('aurora', 2),
  'sternschnuppe': _model('sternschnuppe', 3),
};

/// Eigene Modelle für Entwicklungsstufen: Art → Stufe → Modell-Id. Hut,
/// Augen und Spuren stehen in den Tabellen unter dieser Id.
const stageModels = <String, Map<int, String>>{
  'funkel': {2: 'funkel2', 3: 'funkel3'},
  'moosel': {2: 'moosel2', 3: 'moosel3'},
  'pfuetzling': {2: 'pfuetzling2', 3: 'pfuetzling3'},
  'kieselchen': {2: 'kieselchen2', 3: 'kieselchen3'},
  'schnirp': {2: 'schnirp2', 3: 'schnirp3'},
  'pustel': {2: 'pustel2', 3: 'pustel3'},
  'brummli': {2: 'brummli2', 3: 'brummli3'},
  'zapfi': {2: 'zapfi2', 3: 'zapfi3'},
  'laternchen': {2: 'laternchen2', 3: 'laternchen3'},
  'wolkenwuff': {2: 'wolkenwuff2', 3: 'wolkenwuff3'},
  'blitzmaus': {2: 'blitzmaus2', 3: 'blitzmaus3'},
  'blaetterdrache': {2: 'blaetterdrache2', 3: 'blaetterdrache3'},
  'pilzling': {2: 'pilzling2', 3: 'pilzling3'},
  'kristallis': {2: 'kristallis2', 3: 'kristallis3'},
  'fluffeule': {2: 'fluffeule2', 3: 'fluffeule3'},
};

/// Welches Modell [species] auf [stage] trägt und wie viele Stufen ihm
/// noch fehlen. Ohne eigenes Modell zeigt es das der Stufe davor, etwas
/// größer und mit Funkeln.
({String id, int missing}) stageModelOf(String species, int stage) {
  for (var s = stage; s > 1; s--) {
    final id = stageModels[species]?[s];
    if (id != null) return (id: id, missing: stage - s);
  }
  return (id: species, missing: stage - 1);
}
