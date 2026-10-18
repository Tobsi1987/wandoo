/// Hauptschalter: Schmutzigwerden und Baden sind vorerst aus.
/// Code und Modelle bleiben; einschalten mit
/// `--dart-define=WANDOO_BATH=true`.
const bathEnabled = bool.fromEnvironment('WANDOO_BATH');
