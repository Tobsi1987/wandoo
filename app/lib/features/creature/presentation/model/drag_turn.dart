import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Dreht das Wesen, wenn man mit dem Finger oder der Maus zur Seite
/// wischt. Nach dem Loslassen dreht es mit etwas Schwung weiter.
///
/// [angle] ist die Drehung in Radiant.
class DragTurn extends StatefulWidget {
  const DragTurn({
    required this.angle,
    required this.size,
    required this.child,
    super.key,
  });

  final ValueNotifier<double> angle;
  final double size;
  final Widget child;

  @override
  State<DragTurn> createState() => _DragTurnState();
}

class _DragTurnState extends State<DragTurn>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_coast);
  Duration _last = Duration.zero;

  /// Schwung in Radiant pro Sekunde.
  double _speed = 0;

  /// Ein ganzes Wischen über die Figur ist etwa eine halbe Drehung.
  /// Negativ, damit das Gesicht dem Finger folgt.
  double get _perPixel => -3.2 / widget.size;

  void _coast(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    widget.angle.value += _speed * dt;
    _speed *= 1 - (dt * 3).clamp(0, 1);
    if (_speed.abs() < 0.05) _ticker.stop();
  }

  void _stop() {
    _ticker.stop();
    _speed = 0;
  }

  void _fling(DragEndDetails d) {
    _speed = (d.velocity.pixelsPerSecond.dx * _perPixel).clamp(-12, 12);
    _last = Duration.zero;
    if (_speed.abs() >= 0.05) _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (_) => _stop(),
      onHorizontalDragUpdate: (d) =>
          widget.angle.value += d.delta.dx * _perPixel,
      onHorizontalDragEnd: _fling,
      child: MouseRegion(cursor: SystemMouseCursors.grab, child: widget.child),
    );
  }
}
