import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/presentation/widgets/celebration_burst.dart';
import 'package:wandoo/features/creature/presentation/widgets/celebration_pose.dart';
import 'package:wandoo/features/creature/presentation/widgets/celebration_posed.dart';
import 'package:wandoo/features/creature/presentation/widgets/celebration_stage.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_figure.dart';
import 'package:wandoo/features/creature/presentation/widgets/greeting_bubble.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_motions.dart';

/// Spielt kleine Momente ab, wenn sich das Wesen ändert: Nach dem Fressen
/// hüpft es vor Freude. Beim Schlüpfen platzt das Ei, das Wesen springt
/// mit einer Drehung heraus und winkt.
///
/// Wartet damit, bis die Figur wirklich zu sehen ist (kein anderer
/// Bildschirm darüber, keine [CelebrationStage] hält an) und das
/// 3D-Modell geladen ist.
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

class _CreatureCelebrationState extends State<CreatureCelebration>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);
  CelebrationMoment? _pending;
  CelebrationMoment? _playing;

  /// Das Ei vor dem Schlüpfen, solange es noch zu sehen ist.
  Creature? _egg;

  /// Nächster Freudenhüpfer beim Jubeln.
  Timer? _again;

  @override
  void initState() {
    super.initState();
    if (widget.cheer) _pending = CelebrationMoment.jump;
  }

  @override
  void didUpdateWidget(CreatureCelebration old) {
    super.didUpdateWidget(old);
    final before = old.creature;
    final now = widget.creature;
    if (!before.hatched && now.hatched) {
      _pending = CelebrationMoment.hatch;
      _egg = before;
    } else if (now.food > before.food && _pending == null) {
      _pending = CelebrationMoment.hop;
    } else if (widget.cheer && !old.cheer && _pending == null) {
      _pending = CelebrationMoment.jump;
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
    if (moment == null || _held(moment)) return;
    _pending = null;
    // Solange das Ei schlüpft, unterbricht kein Hüpfer: sonst bliebe es.
    if (_egg != null && moment != CelebrationMoment.hatch) return;
    final reduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (!CreatureFigure.moving || reduced) {
      setState(() => _egg = null);
      return;
    }
    final ready = moment == CelebrationMoment.hatch
        ? CreatureFigure.preload(widget.creature)
        : Future<void>.value();
    unawaited(
      ready.timeout(const Duration(seconds: 4), onTimeout: () {}).then((_) {
        if (!mounted) return;
        // Während des Ladens kann die Bühne angehalten haben.
        if (_held(moment)) {
          _pending ??= moment;
          return;
        }
        _announce(moment);
        setState(() => _playing = moment);
        _controller.duration = Duration(milliseconds: moment.millis);
        unawaited(_controller.forward(from: 0).whenComplete(_done));
      }),
    );
  }

  /// Mitjubeln beim Laufen wartet nie, die großen Momente schon.
  bool _held(CelebrationMoment moment) =>
      !TickerMode.valuesOf(context).enabled ||
      (moment.big && CelebrationStage.holding(context));

  void _announce(CelebrationMoment moment) {
    if (moment.big) CelebrationStage.played(context, moment, widget.creature);
  }

  void _done() {
    if (!mounted) return;
    setState(() {
      if (_playing == CelebrationMoment.hatch) _egg = null;
      _playing = null;
    });
    if (widget.cheer) {
      _again?.cancel();
      _again = Timer(const Duration(milliseconds: 450), () {
        if (!mounted || !widget.cheer || _pending != null) return;
        _pending = CelebrationMoment.jump;
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
          CelebrationMoment.hatch => CelebrationPose.hatch(t),
          CelebrationMoment.hop => CelebrationPose.hop(t),
          CelebrationMoment.jump => CelebrationPose.jump(t),
          null => CelebrationPose(egg: _egg != null),
        };
        final shown = pose.egg ? _egg ?? widget.creature : widget.creature;
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

  Motion? _motion(CelebrationPose pose) => switch (_playing) {
    _ when widget.cheer => null,
    CelebrationMoment.hatch => pose.greeting > 0 ? Motion.wave : Motion.happy,
    CelebrationMoment.hop || CelebrationMoment.jump => Motion.happy,
    null => null,
  };

  /// Ein geriggtes Modell bewegt sich passend; sonst gilt eine Bewegung
  /// von außen (Streicheln).
  Widget _posed(CelebrationPose pose, Creature shown) => posedFigure(
    pose: pose,
    size: widget.size,
    model: CreatureFigure.hasModel(shown),
    child: CreatureMotion(
      motion: _motion(pose) ?? CreatureMotion.of(context),
      child: widget.builder(shown),
    ),
  );
}
