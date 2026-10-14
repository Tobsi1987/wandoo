import 'package:flutter/widgets.dart';
import 'package:wandoo/features/creature/domain/creature.dart';

/// Die Entwicklungsstufe (1 bis 3) des aktuellen Wesens. Gilt nur für genau
/// dieses Wesen, nicht für Figuren anderer Arten im Album.
class CreatureEvolution extends InheritedWidget {
  const CreatureEvolution({
    required this.creature,
    required this.stage,
    required super.child,
    super.key,
  });

  final Creature? creature;
  final int stage;

  /// Die Stufe von [creature], 1 wenn es nicht das aktuelle Wesen ist.
  static int of(BuildContext context, Creature creature) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<CreatureEvolution>();
    final own = scope?.creature;
    if (scope == null || own == null || !creature.hatched) return 1;
    final same =
        own.lineKey == creature.lineKey && own.speciesId == creature.speciesId;
    return same ? scope.stage.clamp(1, 3) : 1;
  }

  /// Wie viel größer das Wesen ist, wenn seinem Modell [stage] − 1 Stufen
  /// fehlen (siehe `stageModelOf`).
  static double scaleFor(int stage) => switch (stage) {
    3 => 1.16,
    2 => 1.08,
    _ => 1.0,
  };

  @override
  bool updateShouldNotify(CreatureEvolution oldWidget) =>
      oldWidget.stage != stage || oldWidget.creature != creature;
}
