import 'package:flutter/material.dart';
import 'package:wandoo/features/world/domain/world_state.dart';
import 'package:wandoo/features/world/presentation/widgets/weather_painter.dart';

/// Himmel hinter dem Wesen: Sterne nachts, Regen, Schnee, Nebel, Sonne.
class WeatherLayer extends StatefulWidget {
  const WeatherLayer({required this.world, this.painted = false, super.key});

  final WorldState world;

  /// Vor einem gemalten Bild: ohne eigene Sterne, Mond und Sonne.
  final bool painted;

  /// In Tests aus, damit `pumpAndSettle` zur Ruhe kommt.
  @visibleForTesting
  static bool animate = true;

  @override
  State<WeatherLayer> createState() => _WeatherLayerState();
}

class _WeatherLayerState extends State<WeatherLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 60),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (WeatherLayer.animate && !reduced && !_clock.isAnimating) {
      _clock.repeat();
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(
      size: Size.infinite,
      painter: WeatherPainter(world: widget.world, clock: _clock),
    ),
  );
}
