import 'package:flutter/widgets.dart';
import 'package:wandoo/features/creature/domain/creature.dart';

/// Wie schmutzig das aktuelle Wesen gerade ist (0 bis 3). Gilt nur für
/// genau dieses Wesen, nicht für Figuren anderer Arten im Album.
class CreatureMud extends InheritedWidget {
  const CreatureMud({
    required this.creature,
    required this.level,
    required super.child,
    super.key,
  });

  final Creature? creature;
  final int level;

  /// Der Matsch an [creature], 0 wenn er nicht zu ihm gehört.
  static int of(BuildContext context, Creature creature) {
    final scope = context.dependOnInheritedWidgetOfExactType<CreatureMud>();
    final own = scope?.creature;
    if (scope == null || own == null) return 0;
    final same =
        own.lineKey == creature.lineKey &&
        own.speciesId == creature.speciesId &&
        own.food == creature.food;
    return same ? scope.level : 0;
  }

  @override
  bool updateShouldNotify(CreatureMud oldWidget) =>
      oldWidget.level != level || oldWidget.creature != creature;
}
