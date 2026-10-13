import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/domain/species_catalog.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_painter.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_shader_uniforms.dart';
import 'package:wandoo/features/creature/presentation/species_looks.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_model.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_anchors.dart';
import 'package:wandoo/features/world/world.dart';

/// Die Figur des Wesens: das 3D-Modell der Art, sonst animiertes 3D aus
/// `shaders/creature.frag`.
///
/// Der einzige Ort, der entscheidet, wie das Wesen aussieht. Eier, Umrisse
/// und Arten ohne Modell zeichnet der Shader; solange der Shader lädt oder
/// fehlt, zeigt es die 2D-Figur.
class CreatureFigure extends StatefulWidget {
  const CreatureFigure({
    required this.creature,
    this.size = 180,
    this.silhouette = false,
    this.world,
    this.still = false,
    super.key,
  });

  final Creature creature;
  final double size;

  /// Nur der dunkle Umriss, z. B. für noch unentdeckte Arten im Album.
  final bool silhouette;

  /// Nacht und Jahreszeit; ohne Angabe Tag und schlichtes Ei.
  final WorldState? world;

  /// Steht still, z. B. im Album: viele Figuren auf einmal bleiben so
  /// sparsam.
  final bool still;

  /// In Tests aus, damit `pumpAndSettle` zur Ruhe kommt.
  @visibleForTesting
  static bool animate = true;

  /// Ob Figuren sich bewegen dürfen (in Tests nicht).
  static bool get moving => animate;

  /// In Tests aus: dort gibt es kein 3D.
  @visibleForTesting
  static bool models = true;

  static const shaderAsset =
      'lib/features/creature/presentation/shaders/creature.frag';

  static final Future<FragmentProgram?> _program = FragmentProgram.fromAsset(
    shaderAsset,
  ).then<FragmentProgram?>((p) => p, onError: (Object _) => null);

  /// Lädt das 3D-Modell von [creature] vorab, falls es eins gibt.
  static Future<void> preload(Creature creature) async {
    final asset = _modelAssetOf(creature);
    if (asset != null) await CreatureModel.preload(asset);
  }

  static String? _modelAssetOf(Creature c) {
    if (!models || !c.hatched) return null;
    return speciesLooks[SpeciesCatalog.byId(c.speciesId).id]?.modelAsset;
  }

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
    if (CreatureFigure.animate && !widget.still && !reduced) _ticker.start();
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
    final drawn = _drawn(sleepy);
    final asset = _modelAsset();
    if (asset == null) return drawn;
    final c = widget.creature;
    final night = widget.world?.night ?? false;
    return CreatureModel(
      asset: asset,
      anchors: ModelAnchors.of(SpeciesCatalog.byId(c.speciesId).id),
      hat: c.hat,
      neck: c.neck,
      size: widget.size,
      fallback: drawn,
      sleepy: sleepy || night,
      night: night,
      grownUp: c.stage == GrowthStage.adult,
      animate: CreatureFigure.animate && !widget.still,
    );
  }

  String? _modelAsset() =>
      widget.silhouette ? null : CreatureFigure._modelAssetOf(widget.creature);

  Widget _drawn(bool sleepy) {
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
