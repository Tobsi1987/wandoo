import 'package:flutter/material.dart';
import 'package:wandoo/features/world/domain/daytime.dart';
import 'package:wandoo/features/world/domain/world_state.dart';
import 'package:wandoo/features/world/presentation/widgets/sky_box.dart';
import 'package:wandoo/features/world/presentation/widgets/weather_layer.dart';

/// Die Welt des Wesens über den ganzen Bildschirm: Himmel nach Tageszeit,
/// Wetter und eine Wiese, auf der das Wesen steht.
///
/// Gibt es für die Tageszeit ein gemaltes Bild, steht es dahinter; sonst
/// zeichnet es Himmel und Wiese selbst.
class WorldBackdrop extends StatelessWidget {
  const WorldBackdrop({required this.world, this.groundAt = 0.6, super.key});

  final WorldState world;

  /// Wo die Wiese beginnt, als Anteil der Höhe von oben.
  final double groundAt;

  /// Gemalte Hintergründe (Midjourney) je Tageszeit, dazu wie stark das
  /// Bild vergrößert wird, damit der Horizont über den Füßen des Wesens
  /// liegt.
  static const Map<Daytime, (String, double)> pictures = {
    Daytime.morning: ('assets/world/morning.jpg', 1.3),
    Daytime.day: ('assets/world/day.jpg', 1.3),
    Daytime.evening: ('assets/world/evening.jpg', 1.6),
  };

  @override
  Widget build(BuildContext context) {
    final picture = pictures[world.daytime];
    if (picture == null) return _drawn();
    final (asset, zoom) = picture;
    return Stack(
      fit: StackFit.expand,
      children: [
        LayoutBuilder(
          builder: (context, box) => Stack(
            children: [
              // Größer und unten bündig: So rückt der Horizont des Bilds
              // nach oben und das Wesen steht auf der Wiese.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: box.maxHeight * zoom,
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (_, _, _) => _drawn(),
                ),
              ),
            ],
          ),
        ),
        WeatherLayer(world: world),
      ],
    );
  }

  Widget _drawn() => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: SkyBox.colors(world.daytime),
      ),
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        WeatherLayer(world: world),
        IgnorePointer(
          child: CustomPaint(painter: _Meadow(world.daytime, groundAt)),
        ),
      ],
    ),
  );
}

class _Meadow extends CustomPainter {
  const _Meadow(this.daytime, this.top);

  final Daytime daytime;
  final double top;

  (Color, Color) get _colors => switch (daytime) {
    Daytime.morning => (const Color(0xFFCDE8B5), const Color(0xFFB4DB98)),
    Daytime.day => (const Color(0xFFC4E6A8), const Color(0xFFA8D68A)),
    Daytime.evening => (const Color(0xFFC9DDA0), const Color(0xFFB2CF8A)),
    Daytime.night => (const Color(0xFF2E3B5E), const Color(0xFF26324F)),
  };

  @override
  void paint(Canvas canvas, Size size) {
    final (back, front) = _colors;
    final y = size.height * top;
    final w = size.width;
    canvas
      ..drawOval(
        Rect.fromLTRB(-w * 0.6, y, w * 0.9, y + size.height),
        Paint()..color = back,
      )
      ..drawOval(
        Rect.fromLTRB(w * 0.05, y + 18, w * 1.7, y + size.height),
        Paint()..color = back,
      )
      ..drawRect(
        Rect.fromLTRB(0, y + 60, w, size.height),
        Paint()..color = front,
      )
      ..drawOval(
        Rect.fromLTRB(-w * 0.3, y + 34, w * 1.3, y + 140),
        Paint()..color = front,
      );
  }

  @override
  bool shouldRepaint(_Meadow old) => old.daytime != daytime || old.top != top;
}
