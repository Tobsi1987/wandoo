import 'package:flutter_scene/scene.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_surface.dart';
import 'package:wandoo/features/creature/presentation/marks/model_marks.dart';
import 'package:wandoo/features/creature/presentation/model/model_eyes.dart';
import 'package:wandoo/features/creature/presentation/model/model_look.dart';
import 'package:wandoo/features/creature/presentation/outfit/model_accessories.dart';

/// Zieht einem 3D-Modell alles aus [ModelLook] an.
class ModelDress {
  final _parts = <Node>[];

  /// Zieht alles neu an; [pivot] trägt das Modell.
  void apply(Node pivot, ModelLook look) {
    for (final part in _parts) {
      part.detach();
    }
    _parts
      ..clear()
      ..addAll([
        if ((MarkSurface.of(look.species), look.mark) case (
          final surface?,
          final mark?,
        ))
          ?modelMarks(surface, look.anchors, mark, headFree: look.headFree),
        if (MarkSurface.of(look.species) case final surface? when look.mud > 0)
          ?modelMud(surface, look.mud),
        if (!look.outfit.isEmpty) modelAccessories(look.anchors, look.outfit),
        if (look.eyes case final eyes? when look.eyesClosed) modelEyelids(eyes),
      ])
      ..forEach(pivot.add);
  }

  /// Nach `pivot.removeAll()`: nichts mehr angezogen.
  void forget() => _parts.clear();
}
