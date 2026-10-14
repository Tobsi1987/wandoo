import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Schaum unter dem Finger: Wischen lässt Bläschen entstehen, die nach
/// einem Moment zerplatzen. Meldet jede gewischte Strecke an [onScrub].
class FoamLayer extends StatefulWidget {
  const FoamLayer({required this.onScrub, super.key});

  /// Die gewischte Strecke in Pixeln.
  final ValueChanged<double> onScrub;

  @override
  State<FoamLayer> createState() => _FoamLayerState();
}

class _FoamLayerState extends State<FoamLayer>
    with SingleTickerProviderStateMixin {
  final _bubbles = <_Bubble>[];
  final _random = math.Random(3);
  final _now = ValueNotifier<Duration>(Duration.zero);
  late final Ticker _ticker = createTicker((t) {
    _now.value = t;
    _bubbles.removeWhere((b) => t - b.born > _Bubble.life);
    if (_bubbles.isEmpty) _ticker.stop();
  });

  void _scrub(DragUpdateDetails d) {
    widget.onScrub(d.delta.distance);
    if (!_ticker.isActive) {
      _now.value = Duration.zero;
      _ticker.start();
    }
    for (var i = 0; i < 2; i++) {
      _bubbles.add(
        _Bubble(
          d.localPosition +
              Offset(
                _random.nextDouble() * 30 - 15,
                _random.nextDouble() * 30 - 15,
              ),
          4 + _random.nextDouble() * 10,
          _now.value,
        ),
      );
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _now.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    key: const Key('foam'),
    behavior: HitTestBehavior.opaque,
    onPanUpdate: _scrub,
    child: CustomPaint(
      painter: _FoamPainter(_bubbles, _now),
      size: Size.infinite,
    ),
  );
}

class _Bubble {
  _Bubble(this.at, this.radius, this.born);

  static const life = Duration(milliseconds: 1200);

  final Offset at;
  final double radius;
  final Duration born;
}

class _FoamPainter extends CustomPainter {
  _FoamPainter(this.bubbles, this.now) : super(repaint: now);

  final List<_Bubble> bubbles;
  final ValueNotifier<Duration> now;

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in bubbles) {
      final age =
          (now.value - b.born).inMicroseconds / _Bubble.life.inMicroseconds;
      final fade = (1 - age).clamp(0.0, 1.0);
      final at = b.at - Offset(0, age * 24);
      final r = b.radius * (0.7 + age * 0.5);
      canvas
        ..drawCircle(
          at,
          r,
          Paint()..color = Colors.white.withValues(alpha: 0.7 * fade),
        )
        ..drawCircle(
          at,
          r,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2
            ..color = Colors.lightBlue.withValues(alpha: 0.6 * fade),
        )
        ..drawCircle(
          at - Offset(r * 0.35, r * 0.35),
          r * 0.22,
          Paint()..color = Colors.white.withValues(alpha: fade),
        );
    }
  }

  @override
  bool shouldRepaint(_FoamPainter old) => true;
}
