import 'dart:math' as math;

import 'package:flutter/animation.dart';

/// Wie die Figur in einem Moment der Feier steht. Reine Zahlen, damit
/// Ablauf und Darstellung getrennt bleiben.
class CelebrationPose {
  const CelebrationPose({
    this.egg = false,
    this.shake = 0,
    this.scale = 1,
    this.lift = 0,
    this.squash = 0,
    this.spin = 0,
    this.sway = 0,
    this.burst = 0,
    this.greeting = 0,
  });

  /// Schlüpfen: Ei zittert, platzt, Wesen springt mit einer Drehung
  /// heraus, landet und winkt.
  factory CelebrationPose.hatch(double t) {
    const open = 0.16;
    const land = 0.5;
    if (t < open) {
      final k = t / open;
      return CelebrationPose(
        egg: true,
        shake: math.sin(t * 160) * 0.12 * k,
        scale: 1 + 0.12 * k,
      );
    }
    final burst = ((t - open) / 0.4).clamp(0.0, 1.0);
    if (t < land) {
      final j = (t - open) / (land - open);
      return CelebrationPose(
        scale: 0.3 + 0.7 * Curves.easeOutBack.transform(math.min(j / 0.3, 1)),
        lift: 0.24 * 4 * j * (1 - j),
        spin: 2 * math.pi * Curves.easeInOut.transform(j),
        burst: burst,
      );
    }
    final squash = (1 - (t - land) / 0.05).clamp(0.0, 1.0);
    final w = ((t - 0.55) / 0.37).clamp(0.0, 1.0);
    final greeting =
        ((t - 0.55) / 0.05).clamp(0.0, 1.0) * ((1 - t) / 0.06).clamp(0.0, 1.0);
    return CelebrationPose(
      squash: squash,
      sway: 0.26 * math.sin(2 * math.pi * 3 * w) * math.sin(math.pi * w),
      burst: burst,
      greeting: greeting,
    );
  }

  /// Zwei Freudenhüpfer, mit Stauchen beim Landen.
  factory CelebrationPose.hop(double t) {
    if (t <= 0 || t >= 1) return rest;
    final phase = t * 2;
    final hop = phase % 1;
    return CelebrationPose(
      lift: 0.14 * 4 * hop * (1 - hop) * (phase < 1 ? 1.0 : 0.55),
      squash: math.pow(1 - math.min(hop, 1 - hop) * 2, 8).toDouble(),
    );
  }

  /// Noch das alte Ei zeigen.
  final bool egg;

  /// Zittern des Eis, in Radiant.
  final double shake;
  final double scale;

  /// Sprunghöhe als Anteil der Figurgröße.
  final double lift;

  /// 1 = ganz gestaucht beim Landen.
  final double squash;

  /// Drehung um die Hochachse, in Radiant.
  final double spin;

  /// Seitliches Wiegen beim Winken, in Radiant.
  final double sway;

  /// Fortschritt von Blitz und Schalenstücken (0 = keine).
  final double burst;

  /// Wie sichtbar die Sprechblase "Hallo!" ist (0 bis 1).
  final double greeting;

  static const rest = CelebrationPose();
}
