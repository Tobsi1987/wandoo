/// Wetter, grob genug für Kinder und Animationen.
enum Weather {
  clear,
  cloudy,
  fog,
  rain,
  snow,
  storm;

  /// Aus dem WMO-Wettercode, wie ihn Open-Meteo liefert.
  static Weather fromWmo(int code) => switch (code) {
    0 || 1 => clear,
    2 || 3 => cloudy,
    45 || 48 => fog,
    >= 71 && <= 77 || 85 || 86 => snow,
    >= 95 => storm,
    >= 51 && <= 67 || >= 80 && <= 82 => rain,
    _ => cloudy,
  };
}
