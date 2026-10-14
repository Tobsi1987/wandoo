import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/petting/application/petting_providers.dart';
import 'package:wandoo/features/petting/presentation/widgets/floating_hearts.dart';
import 'package:wandoo/features/sounds/sounds.dart';

/// Macht die Figur antippbar: Das Wesen freut sich, hüpft und Herzchen
/// steigen auf. Schläft es, gibt es nur ein paar kleine Herzen.
class Pettable extends ConsumerStatefulWidget {
  const Pettable({required this.child, this.asleep = false, super.key});

  final Widget child;
  final bool asleep;

  @override
  ConsumerState<Pettable> createState() => _PettableState();
}

class _PettableState extends ConsumerState<Pettable>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  );

  /// Bei einem neuen Herz steigen mehr Herzchen auf.
  bool _newHeart = false;

  Future<void> _pet() async {
    unawaited(HapticFeedback.lightImpact());
    setState(() => _newHeart = false);
    _controller.forward(from: 0);
    final species = ref.read(creatureProvider).value?.speciesId;
    final sound = ref.read(playSoundProvider);
    unawaited(sound(widget.asleep ? Cue.yawn : Cue.happy, speciesId: species));
    final grew = await ref.read(petCreatureProvider)();
    if (!mounted || !grew) return;
    setState(() => _newHeart = true);
    unawaited(sound(Cue.purr, speciesId: species));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Immer derselbe Aufbau, damit die Figur beim Schlüpfen ihren Zustand
    // behält; Eier lassen sich nur noch nicht streicheln.
    final hatched = ref.watch(creatureProvider).value?.hatched ?? false;
    return Semantics(
      button: hatched,
      label: hatched ? 'Wesen streicheln' : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: hatched ? _pet : null,
        child: AnimatedBuilder(
          animation: _controller,
          child: widget.child,
          builder: (context, child) {
            final t = _controller.value;
            final active = _controller.isAnimating;
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                CreatureMotion(
                  motion: active && !widget.asleep ? Motion.happy : null,
                  child: Transform.scale(
                    scaleY: 1 + (widget.asleep ? 0 : 0.05 * _bounce(t)),
                    scaleX: 1 - (widget.asleep ? 0 : 0.03 * _bounce(t)),
                    alignment: Alignment.bottomCenter,
                    child: child,
                  ),
                ),
                if (active)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: FloatingHearts(
                        progress: t,
                        count: widget.asleep ? 3 : (_newHeart ? 12 : 6),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  static double _bounce(double t) => math.sin(t * math.pi * 3) * (1 - t);
}
