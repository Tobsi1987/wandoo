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

  /// null, solange die Stufe noch lädt.
  final int? stage;

  /// Die Stufe von [creature], 1 wenn es nicht das aktuelle Wesen ist.
  static int of(BuildContext context, Creature creature) =>
      known(context, creature) ?? 1;

  /// Wie [of], aber null, solange die Stufe des eigenen Wesens noch lädt.
  static int? known(BuildContext context, Creature creature) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<CreatureEvolution>();
    final own = scope?.creature;
    if (scope == null || own == null || !creature.hatched) return 1;
    final same =
        own.lineKey == creature.lineKey && own.speciesId == creature.speciesId;
    return same ? scope.stage?.clamp(1, 3) : 1;
  }

  /// Wie groß das Wesen auf [stage] dasteht, wenn seinem Modell [missing]
  /// Stufen fehlen (siehe `stageModelOf`). Eigene Stufenmodelle stehen
  /// deutlich größer da, damit sie mächtiger wirken; ein Modell ohne eigene
  /// Stufe wächst nur ein wenig.
  static double scaleFor({required int stage, required int missing}) {
    final model = switch (stage - missing) {
      3 => 1.3,
      2 => 1.15,
      _ => 1.0,
    };
    final grown = switch (missing) {
      >= 2 => 1.16,
      1 => 1.08,
      _ => 1.0,
    };
    return model * grown;
  }

  @override
  bool updateShouldNotify(CreatureEvolution oldWidget) =>
      oldWidget.stage != stage || oldWidget.creature != creature;
}
