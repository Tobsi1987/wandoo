import 'package:flutter/painting.dart';
import 'package:wandoo/features/creature/domain/trait.dart';

/// Farben der Figur. Der Körper färbt sich nach dem stärksten Merkmal.
abstract final class CreaturePalette {
  static const neutral = Color(0xFFB9A6E0);
  static const moss = Color(0xFF4E7D3A);
  static const fin = Color(0xFF3E86B5);
  static const lanternGlow = Color(0xFFFFD45C);
  static const lanternStem = Color(0xFF5B4A3A);
  static const wheat = Color(0xFFC9A23A);
  static const eye = Color(0xFF2B2230);
  static const cheek = Color(0x66F2789A);

  static Color body(Trait? dominant) => switch (dominant) {
    null => neutral,
    Trait.moss => const Color(0xFF8DBF7A),
    Trait.fins => const Color(0xFF7FB8D9),
    Trait.lanterns => const Color(0xFFE8B86A),
    Trait.wheatEars => const Color(0xFFD9C27A),
  };

  static Color outline(Color body) => Color.lerp(body, eye, 0.45)!;
}
