import 'package:flutter_scene/scene.dart';
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/presentation/model/model_anchors.dart';
import 'package:wandoo/features/creature/presentation/model/model_eyes.dart';
import 'package:wandoo/features/creature/presentation/outfit/model_accessories.dart';

/// Hut, Halsschmuck, Wetter-Sachen und Schlaf-Lider an einem 3D-Modell.
class ModelDress {
  Node? _outfit;
  Node? _lids;

  /// Zieht alles neu an; [pivot] trägt das Modell.
  void apply(
    Node pivot, {
    required ModelAnchors anchors,
    required Outfit outfit,
    required EyeSpot? eyes,
    required bool eyesClosed,
  }) {
    _outfit?.detach();
    _outfit = outfit.isEmpty ? null : modelAccessories(anchors, outfit);
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
