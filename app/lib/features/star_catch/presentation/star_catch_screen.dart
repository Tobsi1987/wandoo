import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/sounds/sounds.dart';
import 'package:wandoo/features/star_catch/application/star_catch_providers.dart';
import 'package:wandoo/features/star_catch/domain/star_rain.dart';
import 'package:wandoo/features/star_catch/presentation/widgets/star_catch_overlays.dart';
import 'package:wandoo/features/star_catch/presentation/widgets/star_sky_painter.dart';

/// Das Mini-Spiel: Das Wesen läuft unten unter dem Nachthimmel hin und her
/// und fängt Sternschnuppen. Gute Fänger bekommen Sternsplitter.
class StarCatchScreen extends ConsumerStatefulWidget {
  const StarCatchScreen({super.key, this.random});

  static const path = '/sternschnuppen';

  /// Für Tests: feste Zufallsfolge.
  final math.Random? random;

  @override
  ConsumerState<StarCatchScreen> createState() => _StarCatchScreenState();
}

class _StarCatchScreenState extends ConsumerState<StarCatchScreen>
    with SingleTickerProviderStateMixin {
  late final _rain = StarRain(random: widget.random);
  late final Ticker _ticker = createTicker(_tick);
  final _sparkles = <Sparkle>[];
  late final String? _walkId = ref.read(starCatchWalkProvider);
  Duration _last = Duration.zero;
  double _x = 0.5;
  double _target = 0.5;
  bool _happy = false;
  bool _ended = false;
  int? _shards;

  @override
  void initState() {
    super.initState();
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration now) {
    final dt = math.min(0.05, (now - _last).inMicroseconds / 1e6);
    _last = now;
    setState(() {
      // Das Wesen läuft dem Finger flink, aber nicht sofort hinterher.
      _x += (_target - _x) * math.min(1, dt * 9);
      final caught = _rain.step(dt, _x);
      if (caught > 0) _caught();
      for (final s in _sparkles) {
        s.age += dt * 2.2;
      }
      _sparkles.removeWhere((s) => s.age >= 1);
    });
    if (_rain.over && !_ended) unawaited(_end());
  }

  void _caught() {
    _sparkles.add(Sparkle(_x, _rain.catchLine));
    _happy = true;
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _happy = false);
    }).ignore();
    _play(Cue.found);
  }

  Future<void> _end() async {
    _ended = true;
    _ticker.stop();
    final walk = _walkId;
    final shards = walk == null
        ? 0
        : await ref.read(finishStarCatchProvider)(walk, _rain.caught);
    if (shards > 0) _play(Cue.cheer);
    if (mounted) setState(() => _shards = shards);
  }

  void _play(Cue cue) {
    final c = ref.read(creatureProvider).value;
    ref.read(playSoundProvider)(cue, speciesId: c?.speciesId).ignore();
  }

  void _follow(Offset at, double width) =>
      _target = (at.dx / width).clamp(0.08, 0.92);

  @override
  Widget build(BuildContext context) {
    final creature = ref.watch(creatureProvider).value;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Sternschnuppen'),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF14163A), Color(0xFF2B2F6B), Color(0xFF3F6B5A)],
            stops: [0, 0.75, 1],
          ),
        ),
        child: LayoutBuilder(builder: (_, box) => _game(box, creature)),
      ),
    );
  }

  Widget _game(BoxConstraints box, Creature? creature) {
    final w = box.maxWidth;
    final h = box.maxHeight;
    final size = math.min(w * 0.34, 160).toDouble();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (d) => _follow(d.localPosition, w),
      onPanUpdate: (d) => _follow(d.localPosition, w),
      child: Stack(
        children: [
          CustomPaint(
            size: Size(w, h),
            painter: StarSkyPainter(
              stars: _rain.stars,
              sparkles: _sparkles,
              time: _rain.elapsed,
            ),
          ),
          if (creature != null)
            Positioned(
              left: _x * w - size / 2,
              top: _rain.catchLine * h - size * 0.3,
              child: _figure(creature, size),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight),
              child: StarCatchHud(
                caught: _rain.caught,
                secondsLeft: _rain.secondsLeft.ceil(),
              ),
            ),
          ),
          StarCatchIntro(visible: _rain.elapsed < 2.5),
          if (_ended) _result(creature),
        ],
      ),
    );
  }

  Widget _figure(Creature creature, double size) {
    final moving = (_target - _x).abs() > 0.02;
    return IgnorePointer(
      child: CreatureMotion(
        motion: _happy
            ? Motion.happy
            : moving
            ? Motion.walk
            : Motion.idle,
        child: CreatureFigure(creature: creature, size: size, awake: true),
      ),
    );
  }

  Widget _result(Creature? creature) => StarCatchResult(
    name: creature == null
        ? 'Dein Wesen'
        : SpeciesCatalog.byId(creature.speciesId).name,
    caught: _rain.caught,
    shards: _shards,
    onDone: () => Navigator.of(context).maybePop(),
  );
}
