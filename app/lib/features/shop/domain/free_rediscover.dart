/// Straßen neu entdecken ist alle [every] einmal gratis.
class FreeRediscover {
  const FreeRediscover({this.every = const Duration(days: 7)});

  final Duration every;

  /// Wie lange es noch dauert, bis es wieder gratis ist; null, wenn jetzt.
  Duration? waitLeft(DateTime? last, DateTime now) {
    if (last == null) return null;
    final left = last.add(every).difference(now);
    return left > Duration.zero ? left : null;
  }
}
