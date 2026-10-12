import 'package:flutter/material.dart';

/// Farben und Typografie der App. Ein Ort für das ganze Aussehen.
abstract final class WandooTheme {
  static const _seed = Color(0xFF4E7D3A);

  static ThemeData light() => ThemeData(colorSchemeSeed: _seed);

  static ThemeData dark() =>
      ThemeData(colorSchemeSeed: _seed, brightness: Brightness.dark);
}
