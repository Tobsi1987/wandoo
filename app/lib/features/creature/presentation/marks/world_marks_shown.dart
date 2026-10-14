import 'package:flutter/widgets.dart';

/// Ob die Figuren darunter die Spuren der Welt zeigen oder normal
/// aussehen. Ohne diesen Rahmen zeigen sie sie.
class WorldMarksShown extends InheritedWidget {
  const WorldMarksShown({required this.shown, required super.child, super.key});

  final bool shown;

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<WorldMarksShown>()?.shown ??
      true;

  @override
  bool updateShouldNotify(WorldMarksShown oldWidget) =>
      oldWidget.shown != shown;
}
