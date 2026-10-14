import 'dart:math';

/// Eine fallende Sternschnuppe. [x] und [y] laufen von 0 bis 1, oben links
/// ist (0, 0).
class FallingStar {
  FallingStar({required this.x, required this.speed, this.y = 0});

  final double x;
  double y;

  /// Wie viel der Höhe sie je Sekunde fällt.
  final double speed;
}

/// Das Spiel: Sternschnuppen fallen vom Himmel, das Wesen läuft unten hin
/// und her und fängt sie. Läuft ohne Bildschirm, damit es testbar ist.
class StarRain {
  StarRain({
    Random? random,
    this.seconds = 20,
    this.reach = 0.13,
    this.catchLine = 0.8,
  }) : _random = random ?? Random();

  final Random _random;

  /// So lange regnet es Sterne.
  final double seconds;

  /// So weit links und rechts vom Wesen wird noch gefangen.
  final double reach;

  /// Ab dieser Höhe ist ein Stern beim Wesen.
  final double catchLine;

  final List<FallingStar> stars = [];
  double elapsed = 0;
  int caught = 0;
  int missed = 0;
  double _nextStar = 0.3;

  bool get over => elapsed >= seconds && stars.isEmpty;

  double get secondsLeft => max(0, seconds - elapsed);

  /// Lässt [dt] Sekunden vergehen, das Wesen steht bei [catcherX].
  /// Gibt zurück, wie viele Sterne dabei gefangen wurden.
  int step(double dt, double catcherX) {
    elapsed += dt;
    _spawn(dt);
    var now = 0;
    stars.removeWhere((star) {
      final before = star.y;
      star.y += star.speed * dt;
      final crossed = before < catchLine && star.y >= catchLine;
      if (crossed && (star.x - catcherX).abs() <= reach) {
        now++;
        return true;
      }
      if (star.y > 1.05) {
        missed++;
        return true;
      }
      return false;
    });
    caught += now;
    return now;
  }

  void _spawn(double dt) {
    if (elapsed >= seconds) return;
    _nextStar -= dt;
    if (_nextStar > 0) return;
    // Gegen Ende kommen sie öfter und schneller.
    final pace = elapsed / seconds;
    _nextStar = 0.9 - 0.45 * pace + _random.nextDouble() * 0.3;
    stars.add(
      FallingStar(
        x: 0.08 + _random.nextDouble() * 0.84,
        speed: 0.32 + 0.22 * pace + _random.nextDouble() * 0.1,
      ),
    );
  }
}

/// Wie viele Sternsplitter es für [caught] gefangene Sterne gibt.
int shardsFor(int caught) => caught >= 14
    ? 2
    : caught >= 6
    ? 1
    : 0;
