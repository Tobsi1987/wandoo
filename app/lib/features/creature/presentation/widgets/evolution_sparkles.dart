import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Kleine Sterne, die um ein entwickeltes Wesen funkeln: drei auf Stufe 2,
/// sechs goldene auf Stufe 3.
class EvolutionSparkles extends StatefulWidget {
  const EvolutionSparkles({
    required this.stage,
    required this.size,
    this.animate = true,
    super.key,
  });

  final int stage;
  final double size;
  final bool animate;

  /// [child] mit Sternen darüber; auf Stufe 1 nur [child].
  static Widget around(
    Widget child, {
    required int stage,
    required double size,
    required bool animate,
  }) {
    if (stage <= 1) return child;
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: EvolutionSparkles(stage: stage, size: size, animate: animate),
        ),
      ],
    );
  }

  @override
  State<EvolutionSparkles> createState() => _EvolutionSparklesState();
}

class _EvolutionSparklesState extends State<EvolutionSparkles>
    with SingleTickerProviderStateMixin {
  late final _twinkle = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  // Wo die Sterne sitzen, als Anteil der Größe (von links oben).
  static const _spots = [
    Offset(0.18, 0.28),
    Offset(0.82, 0.22),
    Offset(0.86, 0.62),
    Offset(0.12, 0.66),
    Offset(0.5, 0.08),
    Offset(0.7, 0.42),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.animate) _twinkle.repeat();
  }

  @override
  void dispose() {
    _twinkle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.stage >= 3 ? 6 : (widget.stage == 2 ? 3 : 0);
    if (count == 0) return const SizedBox.shrink();
    final color = widget.stage >= 3
        ? const Color(0xFFFFD45C)
        : const Color(0xFFFFF4C2);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _twinkle,
        builder: (context, _) => Stack(
          children: [
            for (var i = 0; i < count; i++) _star(_spots[i], i / count, color),
          ],
        ),
      ),
    );
  }

  Widget _star(Offset spot, double phase, Color color) {
    final wave = math.sin((_twinkle.value + phase) * 2 * math.pi);
    final glow = widget.animate ? 0.35 + 0.65 * (wave + 1) / 2 : 0.8;
    final s = widget.size;
    return Positioned(
      left: spot.dx * s - 8,
      top: spot.dy * s - 8,
      child: Opacity(
        opacity: glow,
        child: Icon(
          Icons.auto_awesome,
          size: 16 * (0.8 + 0.3 * glow),
          color: color,
          shadows: const [Shadow(blurRadius: 6, color: Color(0x66FFFFFF))],
        ),
      ),
    );
  }
}
