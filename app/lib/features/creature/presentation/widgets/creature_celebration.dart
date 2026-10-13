import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/presentation/widgets/celebration_burst.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_figure.dart';

/// Spielt kleine Momente ab, wenn sich das Wesen ändert: Nach dem Fressen
/// hüpft es vor Freude, beim Schlüpfen springt das Ei auf und das Wesen
/// kommt heraus.
///
/// Wartet damit, bis die Figur wirklich zu sehen ist (kein anderer
/// Bildschirm darüber) und das 3D-Modell geladen ist.
class CreatureCelebration extends StatefulWidget {
  const CreatureCelebration({
    required this.creature,
    required this.size,
    required this.builder,
    super.key,
  });

  final Creature creature;
  final double size;

  /// Baut die Figur; beim Schlüpfen kurz noch für das alte Ei.
  final Widget Function(Creature creature) builder;

  @override
  State<CreatureCelebration> createState() => _CreatureCelebrationState();
}

enum _Moment { hop, hatch }

class _CreatureCelebrationState extends State<CreatureCelebration>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);
  _Moment? _pending;
  _Moment? _playing;

  /// Das Ei vor dem Schlüpfen, solange es noch zu sehen ist.
  Creature? _egg;

  @override
  void didUpdateWidget(CreatureCelebration old) {
    super.didUpdateWidget(old);
    final before = old.creature;
    final now = widget.creature;
    if (!before.hatched && now.hatched) {
      _pending = _Moment.hatch;
      _egg = before;
    } else if (now.food > before.food && _pending == null) {
      _pending = _Moment.hop;
    }
    _maybeStart();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeStart();
  }

  void _maybeStart() {
    final moment = _pending;
    if (moment == null || !TickerMode.valuesOf(context).enabled) return;
    _pending = null;
    final reduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (!CreatureFigure.moving || reduced) {
      setState(() => _egg = null);
      return;
    }
    final ready = moment == _Moment.hatch
        ? CreatureFigure.preload(widget.creature)
        : Future<void>.value();
    unawaited(
      ready.timeout(const Duration(seconds: 4), onTimeout: () {}).then((_) {
        if (!mounted) return;
        setState(() => _playing = moment);
        _controller.duration = Duration(
          milliseconds: moment == _Moment.hatch ? 2400 : 1100,
        );
        unawaited(_controller.forward(from: 0).whenComplete(_done));
      }),
    );
  }

  void _done() {
    if (!mounted) return;
    setState(() {
      _playing = null;
      _egg = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Immer derselbe Aufbau, damit die Figur ihren Zustand behält.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _playing == null ? 0.0 : _controller.value;
        final hatching = _playing == _Moment.hatch;
        final egg = _egg;
        final showEgg = egg != null && (!hatching || t < _open);
        final figure = widget.builder(showEgg ? egg : widget.creature);
        final after = hatching
            ? ((t - _open) / (1 - _open)).clamp(0.0, 1.0)
            : 0.0;
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            _pose(t, after, figure),
            IgnorePointer(
              child: CustomPaint(
                size: Size.square(widget.size),
                painter: CelebrationBurst(hatching ? after : 0),
              ),
            ),
          ],
        );
      },
    );
  }

  static const _open = 0.3;

  /// Hüpfen; beim Schlüpfen erst Ei zittern, dann Wesen herauswachsen.
  Widget _pose(double t, double after, Widget figure) {
    var shake = 0.0;
    var scale = 1.0;
    var hopT = _playing == _Moment.hop ? t : 0.0;
    if (_playing == _Moment.hatch) {
      if (t < _open) {
        shake = math.sin(t * 90) * 0.12 * (t / _open);
        scale = 1 + 0.12 * t / _open;
      } else {
        scale =
            0.25 +
            0.75 * Curves.elasticOut.transform(math.min(after / 0.55, 1));
        hopT = ((after - 0.6) / 0.4).clamp(0.0, 1.0);
      }
    }
    return _hop(
      hopT,
      Transform.rotate(
        angle: shake,
        alignment: Alignment.bottomCenter,
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.bottomCenter,
          child: figure,
        ),
      ),
    );
  }

  /// Zwei Freudenhüpfer, mit Stauchen beim Landen.
  Widget _hop(double t, Widget child) {
    var height = 0.0;
    var squash = 0.0;
    if (t > 0 && t < 1) {
      final phase = t * 2;
      final hop = phase % 1;
      height = 4 * hop * (1 - hop) * (phase < 1 ? 1.0 : 0.55);
      squash = math.pow(1 - math.min(hop, 1 - hop) * 2, 8).toDouble();
    }
    return Transform.translate(
      offset: Offset(0, -widget.size * 0.14 * height),
      child: Transform.scale(
        scaleX: 1 + 0.1 * squash - 0.04 * height,
        scaleY: 1 - 0.1 * squash + 0.06 * height,
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }
}
