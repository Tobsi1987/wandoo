import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_painter.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_shader_uniforms.dart';
import 'package:wandoo/features/world/world.dart';

/// Die Figur des Wesens: animiertes 3D aus `shaders/creature.frag`.
///
/// Der einzige Ort, der entscheidet, wie das Wesen aussieht. Sollen später
/// Modelle vom Designer (.glb) die Figur ersetzen, wird nur dieses Widget
/// getauscht. Solange der Shader lädt oder fehlt, zeigt es die 2D-Figur.
class CreatureFigure extends StatefulWidget {
  const CreatureFigure({
    required this.creature,
    this.size = 180,
    this.silhouette = false,
    this.world,
    super.key,
  });

  final Creature creature;
  final double size;

  /// Nur der dunkle Umriss, z. B. für noch unentdeckte Arten im Album.
  final bool silhouette;

  /// Nacht und Jahreszeit; ohne Angabe Tag und schlichtes Ei.
  final WorldState? world;

  /// In Tests aus, damit `pumpAndSettle` zur Ruhe kommt.
  @visibleForTesting
  static bool animate = true;

  static const shaderAsset =
      'lib/features/creature/presentation/shaders/creature.frag';

  static final Future<FragmentProgram?> _program = FragmentProgram.fromAsset(
    shaderAsset,
  ).then<FragmentProgram?>((p) => p, onError: (Object _) => null);

  @override
  State<CreatureFigure> createState() => _CreatureFigureState();
}

class _CreatureFigureState extends State<CreatureFigure>
    with SingleTickerProviderStateMixin {
  final _time = ValueNotifier<double>(0);
  late final Ticker _ticker = createTicker(
    (elapsed) => _time.value = elapsed.inMicroseconds / 1e6,
  );
  FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    unawaited(CreatureFigure._program.then(_start));
  }

  void _start(FragmentProgram? program) {
    if (!mounted || program == null) return;
    setState(() => _shader = program.fragmentShader());
    final reduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (CreatureFigure.animate && !reduced) _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _time.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sleepy = widget.creature.isSluggish(DateTime.now());
    final shader = _shader;
    if (shader != null) {
      return CustomPaint(
        size: Size.square(widget.size),
        painter: _ShaderPainter(
          shader,
          widget.creature,
          _time,
          sleepy: sleepy,
          silhouette: widget.silhouette,
          world: widget.world,
        ),
      );
    }
    final flat = CustomPaint(
      size: Size.square(widget.size),
      painter: CreaturePainter(creature: widget.creature, sluggish: sleepy),
    );
    if (!widget.silhouette) return flat;
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(silhouetteColor, BlendMode.srcIn),
      child: flat,
    );
  }
}

class _ShaderPainter extends CustomPainter {
  _ShaderPainter(
    this.shader,
    this.creature,
    this.time, {
    required this.sleepy,
    required this.silhouette,
    required this.world,
  }) : super(repaint: time);

  final FragmentShader shader;
  final Creature creature;
  final bool sleepy;
  final bool silhouette;
  final WorldState? world;
  final ValueListenable<double> time;

  @override
  void paint(Canvas canvas, Size size) {
    setCreatureUniforms(
      shader,
      size: size,
      time: time.value,
      creature: creature,
      sleepy: sleepy,
      silhouette: silhouette,
      world: world,
    );
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_ShaderPainter old) =>
      old.creature != creature ||
      old.sleepy != sleepy ||
      old.silhouette != silhouette ||
      old.world != world;
}
