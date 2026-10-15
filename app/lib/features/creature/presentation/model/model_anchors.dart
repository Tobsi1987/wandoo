/// Wo Hut und Halsschmuck auf einem 3D-Modell sitzen, in Modell-Einheiten
/// (Füße auf y = 0, 1 Einheit hoch, vorne ist +z).
///
/// Von Hand an Ansichten der Modelle aus `assets/creatures/` abgemessen.
class ModelAnchors {
  const ModelAnchors({
    required this.hatY,
    required this.hatZ,
    required this.headRadius,
    required this.neckY,
    required this.neckRadius,
  }) : _neckZ = null;

  /// Kurzform für die Tabelle unten: Hut y, z, Kopfradius, Hals y, Radius
  /// und, wo der Hals nicht unter der Stirn liegt, Hals z.
  const ModelAnchors.measured(
    this.hatY,
    this.hatZ,
    this.headRadius,
    this.neckY,
    this.neckRadius, [
    this._neckZ,
  ]);

  /// Oberste Stelle des Kopfes, auf der der Hut aufliegt.
  final double hatY;
  final double hatZ;

  /// Wie breit der Kopf ist; danach richtet sich die Hutgröße.
  final double headRadius;
  final double neckY;
  final double neckRadius;

  final double? _neckZ;

  /// Der Hals sitzt meist etwas weiter hinten als die Stirn.
  double get neckZ => _neckZ ?? hatZ * 0.7;

  /// Mittelmaß für Arten, die noch nicht abgemessen sind.
  static const fallback = ModelAnchors(
    hatY: 0.9,
    hatZ: 0.1,
    headRadius: 0.28,
    neckY: 0.4,
    neckRadius: 0.2,
  );

  static ModelAnchors of(String speciesId) =>
      modelAnchors[speciesId] ?? fallback;
}

/// Abgemessene Punkte je Art: Hut y, z, Kopfradius, Hals y, Halsradius.
const modelAnchors = <String, ModelAnchors>{
  'aurora': ModelAnchors.measured(.86, .15, .22, .36, .21, .05),
  'blaetterdrache': ModelAnchors.measured(.88, .10, .28, .44, .20, .15),
  'blitzmaus': ModelAnchors.measured(.74, 0, .29, .33, .21, 0),
  'brummli': ModelAnchors.measured(.85, .13, .28, .36, .23),
  'fluffeule': ModelAnchors.measured(.92, .05, .30, .5, .33, .05),
  'funkel': ModelAnchors.measured(.92, .10, .28, .47, .20),
  'funkel2': ModelAnchors.measured(.94, .17, .18, .54, .10, .17),
  'funkel3': ModelAnchors.measured(.82, .25, .10, .55, .07, .22),
  'glutling': ModelAnchors.measured(.76, .08, .26, .38, .16, .08),
  'kieselchen': ModelAnchors.measured(.98, 0, .30, .42, .40),
  'kieselchen2': ModelAnchors.measured(.88, .05, .26, .48, .26, .05),
  'kieselchen3': ModelAnchors.measured(.90, -.02, .15, .72, .12, 0),
  'kristallis': ModelAnchors.measured(.85, .08, .28, .30, .22, .02),
  'laternchen': ModelAnchors.measured(.82, 0, .30, .36, .19, 0),
  'moosel': ModelAnchors.measured(.95, .13, .40, .27, .22),
  'moosel2': ModelAnchors.measured(.78, .10, .19, .47, .09, .05),
  'moosel3': ModelAnchors.measured(.63, .12, .12, .44, .07, .08),
  'nebelfuchs': ModelAnchors.measured(.84, .45, .26, .32, .14, .40),
  'pfuetzling': ModelAnchors.measured(.88, 0, .44, .40, .25),
  'pfuetzling2': ModelAnchors.measured(.78, .05, .21, .37, .09, .08),
  'pfuetzling3': ModelAnchors.measured(.88, .17, .12, .69, .06, .19),
  'pilzling': ModelAnchors.measured(.98, 0, .43, .30, .18),
  'pustel': ModelAnchors.measured(.73, .03, .24, .32, .19, .12),
  'schnirp': ModelAnchors.measured(.73, .14, .20, .32, .18),
  'schnirp2': ModelAnchors.measured(.70, .22, .15, .47, .08, .15),
  'schnirp3': ModelAnchors.measured(.80, .14, .10, .58, .06, .10),
  'sternschnuppe': ModelAnchors.measured(.92, 0, .36, .32, .20),
  'wellenwal': ModelAnchors.measured(.82, .10, .25, .30, .35),
  'wolkenwuff': ModelAnchors.measured(.71, .13, .32, .27, .20),
  'zapfi': ModelAnchors.measured(.86, .22, .26, .42, .17),
};
