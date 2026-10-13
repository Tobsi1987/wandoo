import 'package:flutter/widgets.dart';

/// Gibt eine zusätzliche Drehung um die Hochachse an das 3D-Modell
/// darunter weiter, zum Beispiel beim Sprung aus dem Ei.
class CreatureSpin extends InheritedWidget {
  const CreatureSpin({required this.turns, required super.child, super.key});

  /// Drehung in Radiant.
  final double turns;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CreatureSpin>()?.turns ?? 0;

  @override
  bool updateShouldNotify(CreatureSpin old) => old.turns != turns;
}
