import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/districts/domain/district.dart';

/// Kleine Skizze eines Viertels: bekannte Wege kräftig, offene blass.
class DistrictSketch extends StatelessWidget {
  const DistrictSketch({
    required this.district,
    required this.segments,
    required this.knownIds,
    super.key,
  });

  final District district;
  final List<RoadSegment> segments;
  final Set<String> knownIds;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final south = district.row * District.sizeDegrees;
    // Ost-West ist ein Grad kürzer als Nord-Süd, je weiter im Norden.
    final aspect = math.cos(south * math.pi / 180);
    return AspectRatio(
      aspectRatio: aspect,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomPaint(
          painter: _SketchPainter(
            district: district,
            segments: segments,
            knownIds: knownIds,
            known: scheme.primary,
            open: scheme.outline.withValues(alpha: 0.45),
          ),
        ),
      ),
    );
  }
}

class _SketchPainter extends CustomPainter {
  _SketchPainter({
    required this.district,
    required this.segments,
    required this.knownIds,
    required this.known,
    required this.open,
  });

  final District district;
  final List<RoadSegment> segments;
  final Set<String> knownIds;
  final Color known;
  final Color open;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
    );
    final openPaint = _stroke(open, 2);
    final knownPaint = _stroke(known, 4);
    for (final pass in [false, true]) {
      for (final s in segments) {
        if (knownIds.contains(s.id) != pass) continue;
        canvas.drawLine(
          _point(s.start, size),
          _point(s.end, size),
          pass ? knownPaint : openPaint,
        );
      }
    }
  }

  static Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  Offset _point(GeoPoint p, Size size) {
    const deg = District.sizeDegrees;
    final x = (p.longitude - district.col * deg) / deg;
    final y = 1 - (p.latitude - district.row * deg) / deg;
    return Offset(x * size.width, y * size.height);
  }

  @override
  bool shouldRepaint(_SketchPainter old) =>
      old.segments != segments ||
      old.knownIds != knownIds ||
      old.known != known ||
      old.open != open;
}
