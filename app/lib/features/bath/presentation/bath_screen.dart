import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/bath/application/bath_providers.dart';
import 'package:wandoo/features/bath/presentation/widgets/foam_layer.dart';
import 'package:wandoo/features/bath/presentation/widgets/tub.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/sounds/sounds.dart';
import 'package:wandoo/features/world/world.dart';

/// Baden: Mit dem Finger über das Wesen wischen, bis der Matsch weg ist.
class BathScreen extends ConsumerStatefulWidget {
  const BathScreen({super.key});

  static const path = '/baden';

  /// So weit muss man je Stufe Matsch wischen, in Pixeln.
  static const scrubPerLevel = 900.0;

  @override
  ConsumerState<BathScreen> createState() => _BathScreenState();
}

class _BathScreenState extends ConsumerState<BathScreen> {
  /// Wie schmutzig es beim Hineinsteigen war.
  int? _start;
  double _scrubbed = 0;
  bool _clean = false;

  double get _progress => _start == null || _start == 0
      ? 1
      : (_scrubbed / (_start! * BathScreen.scrubPerLevel)).clamp(0, 1);

  int get _shown =>
      _clean ? 0 : ((_start ?? 0) * (1 - _progress)).ceil().clamp(0, 3);

  void _scrub(double distance, Creature creature) {
    if (_clean || (_start ?? 0) == 0) return;
    setState(() => _scrubbed += distance);
    if (_progress < 1) return;
    setState(() => _clean = true);
    unawaited(ref.read(mudRepositoryProvider).save(creature.lineKey, 0));
    unawaited(
      ref.read(playSoundProvider)(Cue.cheer, speciesId: creature.speciesId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final creature = ref.watch(creatureProvider).value;
    if (creature == null) return const Scaffold();
    // Der Matsch kann erst nach dem ersten Bild geladen sein.
    _start = math.max(_start ?? 0, ref.watch(currentMudProvider));
    final name = SpeciesCatalog.byId(creature.speciesId).name;
    final world = ref.watch(worldStateProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Baden'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          WorldBackdrop(world: world, groundAt: 0.5),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, box) => Column(
                children: [
                  Expanded(child: _tubWithCreature(creature, box.maxWidth)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: _plate(_status(name)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Das Wesen sitzt in der Wanne: hinten Rand und Wasser, vorne Wasser,
  /// Schaum und Wand über dem Bauch.
  Widget _tubWithCreature(Creature creature, double width) {
    final tub = width * 0.86;
    final size = width * 0.85;
    // Die Füße liegen etwa auf halber Höhe der Wanne, unter dem Wasser.
    final feet = tub * Tub.ratio * 0.45;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Tub.back(width: tub),
        Padding(
          padding: EdgeInsets.only(bottom: feet),
          child: CreatureMotion(
            motion: _clean ? Motion.happy : null,
            child: CreatureMud(
              creature: creature,
              level: _shown,
              child: CreatureFigure(
                creature: creature,
                size: size,
                awake: true,
              ),
            ),
          ),
        ),
        IgnorePointer(child: Tub.front(width: tub)),
        Positioned.fill(child: FoamLayer(onScrub: (d) => _scrub(d, creature))),
      ],
    );
  }

  /// Heller Hintergrund, damit der Text auf dem Bild lesbar bleibt.
  Widget _plate(Widget child) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.78),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(padding: const EdgeInsets.all(14), child: child),
  );

  Widget _status(String name) {
    final text = Theme.of(context).textTheme.titleMedium;
    if (_clean) return Text('$name ist wieder blitzsauber! ✨', style: text);
    if ((_start ?? 0) == 0) return Text('$name ist schon sauber.', style: text);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Wisch mit dem Finger über $name.', style: text),
        const SizedBox(height: 12),
        LinearProgressIndicator(value: _progress, minHeight: 10),
      ],
    );
  }
}
