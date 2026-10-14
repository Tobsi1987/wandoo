import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/presentation/celebration/celebration_burst.dart';
import 'package:wandoo/features/creature/presentation/celebration/celebration_pose.dart';
import 'package:wandoo/features/creature/presentation/celebration/celebration_stage.dart';
import 'package:wandoo/features/creature/presentation/celebration/evolution_glow.dart';
import 'package:wandoo/features/creature/presentation/model/creature_spin.dart';
import 'package:wandoo/features/creature/presentation/model/model_motions.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_evolution.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_figure.dart';

/// Die Entwicklung zur nächsten Stufe als eigener Moment: Das Wesen steigt
/// in einem Leuchten auf, dreht sich, und im hellsten Augenblick wechselt
/// es zur neuen Gestalt.
///
/// Bis dahin zeigt [child] die alte Stufe. Wie beim Schlüpfen wartet der
/// Moment, bis kein Fenster mehr darüber liegt ([CelebrationStage] hält
/// nicht an, kein anderer Bildschirm davor).
class EvolutionMoment extends StatefulWidget {
  const EvolutionMoment({
    required this.creature,
    required this.size,
    required this.child,
    super.key,
  });

  final Creature creature;
  final double size;
  final Widget child;

  @override
  State<EvolutionMoment> createState() => _EvolutionMomentState();
}

class _EvolutionMomentState extends State<EvolutionMoment>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: CelebrationMoment.evolve.millis),
  );

  /// Die Stufe, die gerade zu sehen ist; null, solange sie lädt.
  int? _shown;

  /// Die Stufe, zu der es sich gleich entwickelt.
  int? _next;

  /// Für welches Wesen [_shown] gilt.
  String? _line;
  bool _starting = false;
  bool _playing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _update();
  }

  @override
  void didUpdateWidget(EvolutionMoment old) {
    super.didUpdateWidget(old);
    _update();
  }

  /// Danach baut Flutter ohnehin neu, darum ohne `setState`.
  void _update() {
    final target = CreatureEvolution.known(context, widget.creature);
    if (target == null) return;
    final shown = _shown;
    final line = widget.creature.lineKey;
    if (shown == null || target <= shown || line != _line) {
      // Erster Blick, anderes Wesen oder zurück: ohne Moment.
      _line = line;
      if (!_playing) _show(target);
      return;
    }
    _next = target;
    _maybeStart();
  }

  void _show(int stage) {
    _shown = stage;
    _next = null;
  }

  bool get _held =>
      !TickerMode.valuesOf(context).enabled ||
      CelebrationStage.holding(context);

  void _maybeStart() {
    final next = _next;
    if (next == null || _starting || _playing || _held) return;
    final reduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (!CreatureFigure.moving || reduced) {
      _show(next);
      return;
    }
    _starting = true;
    final ready = CreatureFigure.preload(widget.creature, stage: next);
    unawaited(
      ready.timeout(const Duration(seconds: 4), onTimeout: () {}).then((_) {
        _starting = false;
        if (!mounted || _held) return;
        CelebrationStage.played(
          context,
          CelebrationMoment.evolve,
          widget.creature,
        );
        setState(() => _playing = true);
        unawaited(_controller.forward(from: 0).whenComplete(_done));
      }),
    );
  }

  void _done() {
    if (!mounted) return;
    setState(() {
      _playing = false;
      _shown = _next ?? _shown;
      _next = null;
    });
    _update();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      final t = _controller.value;
      final pose = _playing ? CelebrationPose.evolve(t) : CelebrationPose.rest;
      final stage = _playing && t >= 0.5 ? _next : _shown;
      final square = Size.square(widget.size);
      // Immer derselbe Aufbau, damit die Figur ihren Zustand behält.
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          _posed(pose, stage),
          IgnorePointer(
            child: CustomPaint(size: square, painter: EvolutionGlow(pose.glow)),
          ),
          IgnorePointer(
            child: CustomPaint(
              size: square,
              painter: CelebrationBurst(pose.burst, shards: false),
            ),
          ),
        ],
      );
    },
  );

  Widget _posed(CelebrationPose pose, int? stage) => Transform.translate(
    offset: Offset(0, -widget.size * pose.lift),
    child: Transform.scale(
      scaleX: 1 + 0.1 * pose.squash,
      scaleY: 1 - 0.1 * pose.squash,
      alignment: Alignment.bottomCenter,
      child: CreatureSpin(
        turns: CreatureSpin.of(context) + pose.spin,
        child: CreatureMotion(
          motion: _playing ? Motion.happy : CreatureMotion.of(context),
          child: CreatureEvolution(
            creature: widget.creature,
            stage: stage,
            child: widget.child,
          ),
        ),
      ),
    ),
  );
}
