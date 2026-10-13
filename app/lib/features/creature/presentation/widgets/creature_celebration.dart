import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/presentation/widgets/celebration_burst.dart';
import 'package:wandoo/features/creature/presentation/widgets/celebration_pose.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_figure.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_spin.dart';
import 'package:wandoo/features/creature/presentation/widgets/greeting_bubble.dart';

/// Spielt kleine Momente ab, wenn sich das Wesen ändert: Nach dem Fressen
/// hüpft es vor Freude. Beim Schlüpfen platzt das Ei, das Wesen springt
/// mit einer Drehung heraus und winkt.
///
/// Wartet damit, bis die Figur wirklich zu sehen ist (kein anderer
/// Bildschirm darüber) und das 3D-Modell geladen ist.
class CreatureCelebration extends StatefulWidget {
  const CreatureCelebration({
    required this.creature,
    required this.size,
    required this.builder,
    this.cheer = false,
    super.key,
  });

  final Creature creature;
  final double size;

  /// Baut die Figur; beim Schlüpfen kurz noch für das alte Ei.
  final Widget Function(Creature creature) builder;

  /// Hüpft immer wieder vor Freude, zum Beispiel während eines Gangs.
  final bool cheer;

  @override
  State<CreatureCelebration> createState() => _CreatureCelebrationState();
}

enum _Moment { hop, jump, hatch }

class _CreatureCelebrationState extends State<CreatureCelebration>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);
  _Moment? _pending;
  _Moment? _playing;

  /// Das Ei vor dem Schlüpfen, solange es noch zu sehen ist.
  Creature? _egg;

  /// Nächster Freudenhüpfer beim Jubeln.
  Timer? _again;

  @override
  void initState() {
    super.initState();
    if (widget.cheer) _pending = _Moment.jump;
  }

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
    } else if (widget.cheer && !old.cheer && _pending == null) {
      _pending = _Moment.jump;
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
          milliseconds: switch (moment) {
            _Moment.hatch => 4400,
            _Moment.hop => 1100,
            _Moment.jump => 650,
          },
        );
        unawaited(_controller.forward(from: 0).whenComplete(_done));
      }),
    );
  }

  void _done() {
    if (!mounted) return;
    setState(() {
      // Ein Freudensprung, der noch zu Ende läuft, während das Schlüpfen
      // schon wartet, darf das Ei nicht wegnehmen.
      if (_playing == _Moment.hatch) _egg = null;
      _playing = null;
    });
    if (widget.cheer) {
      _again?.cancel();
      _again = Timer(const Duration(milliseconds: 450), () {
        if (!mounted || !widget.cheer || _pending != null) return;
        _pending = _Moment.jump;
        _maybeStart();
      });
    }
  }

  @override
  void dispose() {
    _again?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Immer derselbe Aufbau, damit die Figur ihren Zustand behält.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final pose = switch (_playing) {
          _Moment.hatch => CelebrationPose.hatch(t),
          _Moment.hop => CelebrationPose.hop(t),
          _Moment.jump => CelebrationPose.jump(t),
          null => CelebrationPose(egg: _egg != null),
        };
        final egg = _egg;
        final shown = pose.egg && egg != null ? egg : widget.creature;
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            _posed(pose, shown),
            IgnorePointer(
              child: CustomPaint(
                size: Size.square(widget.size),
                painter: CelebrationBurst(pose.burst),
              ),
            ),
            if (pose.greeting > 0) GreetingBubble(visible: pose.greeting),
          ],
        );
      },
    );
  }

  Widget _posed(CelebrationPose pose, Creature shown) {
    final size = widget.size;
    // Mit 3D-Modell dreht sich das Modell selbst, sonst nur ein Umklappen.
    final flat = CreatureFigure.hasModel(shown) ? 1.0 : math.cos(pose.spin);
    final stretch = pose.stretch;
    return Transform.translate(
      offset: Offset(0, -size * pose.lift),
      child: Transform.rotate(
        angle: pose.shake + pose.sway,
        alignment: Alignment.bottomCenter,
        child: Transform.scale(
          scaleX: pose.scale * flat * (1 + 0.1 * pose.squash - 0.04 * stretch),
          scaleY: pose.scale * (1 - 0.1 * pose.squash + 0.06 * stretch),
          alignment: Alignment.bottomCenter,
          child: CreatureSpin(turns: pose.spin, child: widget.builder(shown)),
        ),
      ),
    );
  }
}
