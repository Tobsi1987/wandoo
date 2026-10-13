import 'package:flutter_scene/scene.dart';
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_accessories.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_anchors.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_eyes.dart';

/// Hut, Halsschmuck und Schlaf-Lider an einem 3D-Modell.
class ModelDress {
  Node? _outfit;
  Node? _lids;

  /// Zieht alles neu an; [pivot] trägt das Modell.
  void apply(
    Node pivot, {
    required ModelAnchors anchors,
    required CreatureHat? hat,
    required CreatureNeck? neck,
    required EyeSpot? eyes,
    required bool eyesClosed,
  }) {
    _outfit?.detach();
    _outfit = hat == null && neck == null
        ? null
        : modelAccessories(anchors, hat, neck);
    if (_outfit case final outfit?) pivot.add(outfit);
    _lids?.detach();
    _lids = switch (eyes) {
      final eyes? when eyesClosed => modelEyelids(eyes),
      _ => null,
    };
    if (_lids case final lids?) pivot.add(lids);
  }

  /// Nach `pivot.removeAll()`: nichts mehr angezogen.
  void forget() {
    _outfit = null;
    _lids = null;
  }
}
