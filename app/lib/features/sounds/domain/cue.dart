import 'package:wandoo/features/sounds/domain/voice.dart';

/// Ein kleiner Laut. Stimmen liegen als `assets/sounds/<name>_<lage>.wav`
/// bei, das Glöckchen als `found.wav`.
enum Cue {
  /// Fröhliches Piepsen, z. B. beim Streicheln.
  happy,

  /// Schnurren, wenn es ein neues Herz gibt.
  purr,

  /// Gähnen, wenn man ein schlafendes Wesen antippt.
  yawn,

  /// Jubeln beim Schlüpfen.
  cheer,

  /// Schnüffeln, wenn das Wesen eine neue Spur riecht.
  sniff,

  /// Glöckchen, wenn die Spürnase am Fund ist.
  found;

  /// Datei des Lauts in der Stimme [voice].
  String asset(Voice voice) =>
      voiced ? 'sounds/${name}_${voice.name}.wav' : 'sounds/$name.wav';

  /// Ob der Laut die Stimme des Wesens ist (und so je Art höher oder
  /// tiefer klingt).
  bool get voiced => this != found;
}
