import 'package:flutter/widgets.dart';
import 'package:flutter_scene/scene.dart';

/// Bewegungen, die ein geriggtes Modell im .glb mitbringen kann (die Namen
/// der Animationen dort).
enum Motion { idle, walk, happy, wave, sleep }

/// Spielt die Animationen eines geriggten Modells und blendet weich
/// zwischen ihnen. Modelle ohne Animationen bleiben unberührt.
class ModelMotions {
  ModelMotions(Node model) {
    for (final animation in model.parsedAnimations) {
      final motion = Motion.values.asNameMap()[animation.name];
      if (motion == null) continue;
      _clips[motion] = model.createAnimationClip(animation)
        ..loop = true
        ..weight = motion == Motion.idle ? 1 : 0
        ..play();
    }
  }

  final _clips = <Motion, AnimationClip>{};

  bool get isEmpty => _clips.isEmpty;

  /// Blendet in etwa 0,3 s zu [target] über; fehlt es, zu `idle`.
  void show(Motion target, double seconds) {
    final want = _clips.containsKey(target) ? target : Motion.idle;
    final step = (seconds / 0.3).clamp(0.0, 1.0);
    _clips.forEach((motion, clip) {
      final goal = motion == want ? 1.0 : 0.0;
      clip.weight += (goal - clip.weight) * step;
    });
  }
}

/// Gibt eine Bewegung von außen vor, zum Beispiel Winken beim Schlüpfen.
class CreatureMotion extends InheritedWidget {
  const CreatureMotion({required this.motion, required super.child, super.key});

  final Motion? motion;

  static Motion? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CreatureMotion>()?.motion;

  @override
  bool updateShouldNotify(CreatureMotion old) => old.motion != motion;
}
