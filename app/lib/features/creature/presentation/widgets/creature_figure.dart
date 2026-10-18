import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/domain/species_catalog.dart';
import 'package:wandoo/features/creature/domain/world_mark.dart';
import 'package:wandoo/features/creature/presentation/egg/egg_model.dart';
import 'package:wandoo/features/creature/presentation/marks/creature_mud.dart';
import 'package:wandoo/features/creature/presentation/marks/world_marks_shown.dart';
import 'package:wandoo/features/creature/presentation/model/creature_model.dart';
import 'package:wandoo/features/creature/presentation/model/model_anchors.dart';
import 'package:wandoo/features/creature/presentation/model/model_eyes.dart';
import 'package:wandoo/features/creature/presentation/model/model_loader.dart';
import 'package:wandoo/features/creature/presentation/model/model_look.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_painter.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_shader_painter.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_shader_uniforms.dart';
import 'package:wandoo/features/creature/presentation/species_looks.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_evolution.dart';
import 'package:wandoo/features/creature/presentation/widgets/evolution_sparkles.dart';
import 'package:wandoo/features/world/world.dart';

/// Die Figur des Wesens und der einzige Ort, der entscheidet, wie es
/// aussieht: das 3D-Modell der Art, als Ei [EggModel]. Umrisse und Arten
/// ohne Modell zeichnet `shaders/creature.frag`, bis er lädt die 2D-Figur.
class CreatureFigure extends StatefulWidget {
  const CreatureFigure({
    required this.creature,
    this.size = 180,
    this.silhouette = false,
    this.world,
    this.still = false,
    this.awake = false,
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

  /// Wach und munter, auch nachts, zum Beispiel während eines Gangs.
  final bool awake;

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

  /// Lädt das 3D-Modell von [creature] auf [stage] vorab, falls es eins gibt.
  static Future<void> preload(Creature creature, {int stage = 1}) async {
    if (_modelAssetOf(creature) == null) return;
    final species = SpeciesCatalog.byId(creature.speciesId).id;
    await ModelLoader.load(modelAssetOf(stageModelOf(species, stage).id));
  }

  /// Ob [creature] als 3D-Modell gezeigt wird.
  static bool hasModel(Creature creature) => _modelAssetOf(creature) != null;

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
    final sleepy = !widget.awake && widget.creature.isSluggish(DateTime.now());
    final c = widget.creature;
    final night = widget.world?.night ?? false;
    final moving = CreatureFigure.animate && !widget.still;
    if (!widget.silhouette && CreatureFigure.models && !c.hatched) {
      final (size, world) = (widget.size, widget.world);
      return EggModel.of(c, size: size, world: world, animate: moving);
    }
    final drawn = _drawn(sleepy);
    if (widget.silhouette || !CreatureFigure.hasModel(c)) return drawn;
    final stage = CreatureEvolution.of(context, c);
    final species = SpeciesCatalog.byId(c.speciesId).id;
    final (:id, :missing) = stageModelOf(species, stage);
    final model = CreatureModel(
      asset: modelAssetOf(id),
      look: ModelLook(
        species: id,
        anchors: ModelAnchors.of(id),
        outfit: Outfit(
          hat: c.hat,
          neck: c.neck,
          gear: weatherGear(widget.world?.weather),
        ),
        mark: WorldMarksShown.of(context) ? WorldMark.of(c) : null,
        mud: CreatureMud.of(context, c),
        eyes: modelEyes[id],
      ),
      walking: widget.awake,
      size: widget.size,
      fallback: drawn,
      sleepy: sleepy || (night && !widget.awake),
      night: night,
      scale:
          (c.stage == GrowthStage.adult ? 1.0 : 0.8) *
          CreatureEvolution.scaleFor(stage: stage, missing: missing),
      animate: moving,
    );
    final size = widget.size;
    return EvolutionSparkles.around(
      model,
      stage: missing + 1,
      size: size,
      animate: moving,
    );
  }

  Widget _drawn(bool sleepy) {
    final shader = _shader;
    if (shader != null) {
      return CustomPaint(
        size: Size.square(widget.size),
        painter: CreatureShaderPainter(
          shader,
          widget.creature,
          _time,
          sleepy: sleepy,
          silhouette: widget.silhouette,
          world: widget.world,
          awake: widget.awake,
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
