import 'package:flutter/widgets.dart';
import 'package:wandoo/features/creature/domain/creature.dart';

/// Ein Moment der Feier: Freudenhüpfer nach dem Fressen, ein kurzer
/// Sprung beim Mitlaufen, oder das Schlüpfen.
enum CelebrationMoment {
  hop(1100),
  jump(650),
  hatch(4400);

  const CelebrationMoment(this.millis);
  final int millis;

  /// Große Momente warten auf die Bühne; Mitjubeln beim Laufen nicht.
  bool get big => this != jump;
}

/// Bühne für die Momente darunter: Mit [hold] warten Schlüpfen und
/// Freudenhüpfer, zum Beispiel solange die Zusammenfassung eines Gangs
/// offen ist. [onPlay] meldet, wenn ein Moment wirklich beginnt, damit
/// zum Beispiel ein Ton dazu passt.
class CelebrationStage extends InheritedWidget {
  const CelebrationStage({
    required this.hold,
    required super.child,
    this.onPlay,
    super.key,
  });

  final bool hold;
  final void Function(CelebrationMoment moment, Creature creature)? onPlay;

  /// Ob gerade gewartet wird; baut neu, sobald es weitergeht.
  static bool holding(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CelebrationStage>()?.hold ??
      false;

  /// Meldet einen beginnenden Moment, ohne sich anzumelden.
  static void played(
    BuildContext context,
    CelebrationMoment moment,
    Creature creature,
  ) => context.getInheritedWidgetOfExactType<CelebrationStage>()?.onPlay?.call(
    moment,
    creature,
  );

  @override
  bool updateShouldNotify(CelebrationStage oldWidget) => hold != oldWidget.hold;
}
