import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Was beim Schlüpfen aus dem Ei fliegt: ein heller Blitz, Schalenstücke
/// und Funkelsterne. [progress] läuft von 0 (Ei springt auf) bis 1.
class CelebrationBurst extends CustomPainter {
  CelebrationBurst(this.progress, {this.shards = true});

  final double progress;

  /// Schalenstücke nur beim Schlüpfen, nicht bei der Entwicklung.
  final bool shards;

  static const _shell = Color(0xFFFFF6E6);
  static const _shellEdge = Color(0xFFE8D5B5);
  static const _sparkles = [Color(0xFFFFD86B), Color(0xFFFF9FB2)];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final center = Offset(size.width * 0.5, size.height * 0.6);
    _flash(canvas, center, size.width);
    for (var i = 0; i < (shards ? 8 : 0); i++) {
      _shard(canvas, center, size.width, i);
    }
    for (var i = 0; i < 12; i++) {
      _sparkle(canvas, center, size.width, i);
    }
  }

  void _flash(Canvas canvas, Offset center, double w) {
    final t = progress / 0.35;
    if (t >= 1) return;
    final radius = w * (0.15 + 0.45 * t);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.9 * (1 - t)),
          const Color(0xFFFFF3C4).withValues(alpha: 0.5 * (1 - t)),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  /// Ein Schalenstück fliegt schräg nach oben weg und fällt wieder.
  void _shard(Canvas canvas, Offset center, double w, int i) {
    final t = progress / 0.7;
    if (t >= 1) return;
    final angle = -math.pi / 2 + (i - 3.5) * 0.42;
    final speed = w * (0.55 + 0.12 * (i % 3));
    final out = 1 - (1 - t) * (1 - t);
    final pos =
        center +
        Offset(
          math.cos(angle) * speed * out,
          math.sin(angle) * speed * out + w * 0.6 * t * t,
        );
    final s = w * (0.07 + 0.015 * (i % 2));
    final path = Path()
      ..moveTo(-s, s * 0.5)
      ..lineTo(-s * 0.3, -s * 0.6)
      ..lineTo(0, -s * 0.1)
      ..lineTo(s * 0.4, -s * 0.7)
      ..lineTo(s, s * 0.4)
      ..quadraticBezierTo(0, s * 0.9, -s, s * 0.5)
      ..close();
    final alpha = 1 - t * t;
    canvas
      ..save()
      ..translate(pos.dx, pos.dy)
      ..rotate((i.isEven ? 1 : -1) * t * 5)
      ..drawPath(path, Paint()..color = _shell.withValues(alpha: alpha))
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = _shellEdge.withValues(alpha: alpha),
      )
      ..restore();
  }

  /// Ein Funkelstern mit vier Spitzen, der nach außen schwebt.
  void _sparkle(Canvas canvas, Offset center, double w, int i) {
    final t = (progress - 0.05 * (i % 4)) / 0.8;
    if (t <= 0 || t >= 1) return;
    final angle = i / 12 * 2 * math.pi;
    final pos =
        center + Offset(math.cos(angle), math.sin(angle) * 0.8) * w * 0.42 * t;
    final r = w * 0.035 * math.sin(math.pi * t);
    final paint = Paint()..color = _sparkles[i % 2];
    final star = Path();
    for (var k = 0; k < 8; k++) {
      final a = k * math.pi / 4;
      final d = k.isEven ? r : r * 0.35;
      final p = pos + Offset(math.cos(a), math.sin(a)) * d;
      k == 0 ? star.moveTo(p.dx, p.dy) : star.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(star..close(), paint);
  }

  @override
  bool shouldRepaint(CelebrationBurst old) =>
      old.progress != progress || old.shards != shards;
}
