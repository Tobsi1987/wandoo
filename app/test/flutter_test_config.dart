import 'dart:async';

import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/world/world.dart';

/// Gilt für alle Tests unter `test/`: Figur und Wetter stehen still.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  CreatureFigure.animate = false;
  WeatherLayer.animate = false;
  await testMain();
}
