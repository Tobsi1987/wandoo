import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/den/domain/furniture.dart';
import 'package:wandoo/features/den/presentation/widgets/furniture_floor.dart';
import 'package:wandoo/features/den/presentation/widgets/furniture_play.dart';
import 'package:wandoo/features/den/presentation/widgets/furniture_wall.dart';

typedef _Build = void Function(Node root);

const Map<Furniture, _Build> _builders = {
  Furniture.leafWreath: leafWreath,
  Furniture.shellGarland: shellGarland,
  Furniture.starPicture: starPicture,
  Furniture.glowJar: glowJar,
  Furniture.mushroomLamp: mushroomLamp,
  Furniture.moonLamp: moonLamp,
  Furniture.hayNest: hayNest,
  Furniture.shellBed: shellBed,
  Furniture.cloudBed: cloudBed,
  Furniture.flowerPot: flowerPot,
  Furniture.fern: fern,
  Furniture.waterLily: waterLily,
  Furniture.flowerRug: flowerRug,
  Furniture.waveRug: waveRug,
  Furniture.starRug: starRug,
  Furniture.ball: beachBall,
  Furniture.spinningTop: spinningTop,
  Furniture.toyBoat: toyBoat,
};

/// Ein Möbelstück in 3D, in einem Quadrat: steht unten auf dem Boden.
class FurniturePiece extends StatefulWidget {
  const FurniturePiece({
    required this.furniture,
    required this.size,
    super.key,
  });

  final Furniture furniture;
  final double size;

  /// In Tests aus: Dort gibt es kein 3D.
  static bool render = true;

  @override
  State<FurniturePiece> createState() => _FurniturePieceState();
}

class _FurniturePieceState extends State<FurniturePiece> {
  Scene? _scene;

  @override
  void initState() {
    super.initState();
    if (FurniturePiece.render) _scene = _build(widget.furniture);
  }

  @override
  void didUpdateWidget(FurniturePiece old) {
    super.didUpdateWidget(old);
    if (old.furniture != widget.furniture && FurniturePiece.render) {
      _scene = _build(widget.furniture);
    }
  }

  static Scene _build(Furniture f) {
    final root = Node();
    _builders[f]!(root);
    return Scene()
      ..exposure = 1.3
      ..add(root);
  }

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: widget.size,
    child: switch (_scene) {
      null => null,
      final scene => SceneView(
        scene,
        autoTick: false,
        camera: widget.furniture.spot == Spot.rug ? _flat : _front,
      ),
    },
  );

  /// Leicht von oben, sieht etwa 1,1 Einheiten hoch.
  static final PerspectiveCamera _front = _camera(pitch: 0.3, look: 0.45);

  /// Für Teppiche steiler von oben.
  static final PerspectiveCamera _flat = _camera(pitch: 0.75, look: 0.05);

  static PerspectiveCamera _camera({
    required double pitch,
    required double look,
  }) {
    const distance = 2.2;
    return PerspectiveCamera(
      position: vm.Vector3(
        0,
        look + distance * math.sin(pitch),
        distance * math.cos(pitch),
      ),
      target: vm.Vector3(0, look, 0),
      fovRadiansY: 2 * math.atan(0.56 / distance),
    );
  }
}
