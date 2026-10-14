import 'dart:async';

import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/den/presentation/widgets/furniture_piece.dart';
import 'package:wandoo/features/world/world.dart';

/// Gilt für alle Tests unter `test/`: Figur und Wetter stehen still, ohne 3D-Modelle.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  CreatureFigure.animate = false;
  CreatureFigure.models = false;
  WeatherLayer.animate = false;
  FurniturePiece.render = false;
  await testMain();
}
