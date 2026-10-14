import 'package:flutter/foundation.dart';
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/domain/world_mark.dart';
import 'package:wandoo/features/creature/presentation/model/model_anchors.dart';
import 'package:wandoo/features/creature/presentation/model/model_eyes.dart';

/// Alles, was zusätzlich an einem Modell sitzt: die Spur der Welt, Hut,
/// Halsschmuck, Wetter-Sachen und im Schlaf die Lider.
@immutable
class ModelLook {
  const ModelLook({
    this.species = '',
    this.anchors = ModelAnchors.fallback,
    this.outfit = const Outfit(),
    this.mark,
    this.mud = 0,
    this.eyes,
    this.eyesClosed = false,
  });

  /// Die Art (`Species.id`); nach ihr richten sich die Stellen der Spur.
  final String species;

  /// Wo Hut, Halsschmuck und Schirm auf diesem Modell sitzen.
  final ModelAnchors anchors;
  final Outfit outfit;
  final WorldMark? mark;

  /// Wie schmutzig, 0 bis 3.
  final int mud;

  /// Wo die Augen sitzen; nur damit kann es sie im Schlaf schließen.
  final EyeSpot? eyes;
  final bool eyesClosed;

  bool get asleep => eyesClosed && eyes != null;

  /// Hut oder Mütze lassen oben auf dem Kopf keinen Platz für die Spur.
  bool get headFree => outfit.hat == null && outfit.gear != WeatherGear.beanie;

  @override
  bool operator ==(Object other) =>
      other is ModelLook &&
      other.species == species &&
      other.anchors == anchors &&
      other.outfit == outfit &&
      other.mark == mark &&
      other.mud == mud &&
      other.eyes == eyes &&
      other.eyesClosed == eyesClosed;

  @override
  int get hashCode =>
      Object.hash(species, anchors, outfit, mark, mud, eyes, eyesClosed);
}
