import 'package:flutter/material.dart';
import 'package:wandoo/features/world/domain/daytime.dart';
import 'package:wandoo/features/world/domain/world_state.dart';
import 'package:wandoo/features/world/presentation/widgets/weather_layer.dart';

/// Ein kleines Fenster in die Welt: Himmel nach Tageszeit, darin das
/// Wetter und davor [child], meist das Wesen.
class SkyBox extends StatelessWidget {
  const SkyBox({required this.world, required this.child, super.key});

  final WorldState world;
  final Widget child;

  static List<Color> colors(Daytime t) => switch (t) {
    Daytime.morning => const [Color(0xFFFFF1D6), Color(0xFFE3F2FD)],
    Daytime.day => const [Color(0xFFDCEEFC), Color(0xFFF1F8E9)],
    Daytime.evening => const [Color(0xFFFFD6B0), Color(0xFFD7C4F0)],
    Daytime.night => const [Color(0xFF1E2A4A), Color(0xFF3A4775)],
  };

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(28),
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors(world.daytime),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: WeatherLayer(world: world)),
          Padding(padding: const EdgeInsets.all(12), child: child),
        ],
      ),
    ),
  );
}
