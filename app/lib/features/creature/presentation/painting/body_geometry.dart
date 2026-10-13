import 'dart:math' as math;
import 'dart:ui';

/// Lage und Größe des Körpers auf der Zeichenfläche.
class BodyGeometry {
  const BodyGeometry({
    required this.center,
    required this.radiusX,
    required this.radiusY,
  });

  final Offset center;
  final double radiusX;
  final double radiusY;

  Rect get rect =>
      Rect.fromCenter(center: center, width: radiusX * 2, height: radiusY * 2);

  /// Punkt auf dem Körperrand; 0° ist rechts, -90° oben.
  Offset surface(double degrees, {double grow = 1}) {
    final a = degrees * math.pi / 180;
    return center +
        Offset(math.cos(a) * radiusX * grow, math.sin(a) * radiusY * grow);
  }

  /// Richtung vom Mittelpunkt nach außen beim Winkel [degrees].
  Offset outward(double degrees) {
    final a = degrees * math.pi / 180;
    return Offset(math.cos(a), math.sin(a));
  }
}

/// Wie deutlich ein Merkmal gezeichnet wird: 0 (gar nicht) bis 3.
int traitLevel(int points) {
  if (points <= 0) return 0;
  if (points < 10) return 1;
  if (points < 30) return 2;
  return 3;
}
