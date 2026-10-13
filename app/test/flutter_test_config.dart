import 'dart:async';

import 'package:wandoo/features/creature/creature.dart';

/// Gilt für alle Tests unter `test/`: Die Figur steht still.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  CreatureFigure.animate = false;
  await testMain();
}
