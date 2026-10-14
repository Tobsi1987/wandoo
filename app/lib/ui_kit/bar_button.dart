import 'package:flutter/material.dart';

/// Ein runder Knopf für die obere Leiste: alle gleich groß, jeder mit
/// seiner eigenen sanften Farbe.
class BarButton extends StatelessWidget {
  const BarButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  /// Durchmesser des Kreises.
  static const double size = 40;

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Material(
      color: Color.alphaBlend(color.withValues(alpha: 0.18), Colors.white),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox.square(
          dimension: size,
          child: Icon(icon, size: 22, color: color),
        ),
      ),
    ),
  );
}
