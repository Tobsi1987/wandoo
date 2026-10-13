/// Muster des Eis, je nach Jahreszeit oder Fest.
enum EggTheme {
  spring,
  summer,
  autumn,
  winter,
  easter,
  halloween,
  christmas;

  /// Feste gehen vor: Ostern (Palmsonntag bis Ostermontag), Halloween
  /// (24. bis 31. Oktober), Advent und Weihnachten (1. bis 26. Dezember).
  static EggTheme on(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final sunday = easterSunday(date.year);
    final palmSunday = DateTime(sunday.year, sunday.month, sunday.day - 7);
    final easterMonday = DateTime(sunday.year, sunday.month, sunday.day + 1);
    if (!day.isBefore(palmSunday) && !day.isAfter(easterMonday)) {
      return EggTheme.easter;
    }
    if (date.month == 10 && date.day >= 24) return halloween;
    if (date.month == 12 && date.day <= 26) return christmas;
    return switch (date.month) {
      3 || 4 || 5 => spring,
      6 || 7 || 8 => summer,
      9 || 10 || 11 => autumn,
      _ => winter,
    };
  }

  /// Ostersonntag nach der gregorianischen Osterformel (Meeus/Jones/Butcher).
  static DateTime easterSunday(int year) {
    final a = year % 19;
    final b = year ~/ 100;
    final c = year % 100;
    final d = b ~/ 4;
    final e = b % 4;
    final f = (b + 8) ~/ 25;
    final g = (b - f + 1) ~/ 3;
    final h = (19 * a + b - d - g + 15) % 30;
    final i = c ~/ 4;
    final k = c % 4;
    final l = (32 + 2 * e + 2 * i - h - k) % 7;
    final m = (a + 11 * h + 22 * l) ~/ 451;
    final month = (h + l - 7 * m + 114) ~/ 31;
    final day = (h + l - 7 * m + 114) % 31 + 1;
    return DateTime(year, month, day);
  }
}
