/// Tageszeit, nach der Ortszeit des Geräts.
enum Daytime {
  morning,
  day,
  evening,
  night;

  /// Morgens 6 bis 9, tagsüber bis 17, abends bis 20, danach Nacht.
  static Daytime at(DateTime local) => switch (local.hour) {
    >= 6 && < 10 => morning,
    >= 10 && < 18 => day,
    >= 18 && < 21 => evening,
    _ => night,
  };
}
