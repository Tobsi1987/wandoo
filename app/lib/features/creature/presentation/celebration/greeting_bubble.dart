import 'package:flutter/material.dart';

/// Sprechblase "Hallo!" oben neben dem Kopf, mit der das frisch
/// geschlüpfte Wesen grüßt. [visible] von 0 bis 1 blendet sie ein.
class GreetingBubble extends StatelessWidget {
  const GreetingBubble({required this.visible, super.key});

  final double visible;

  @override
  Widget build(BuildContext context) {
    final pop = Curves.easeOutBack.transform(visible.clamp(0.0, 1.0));
    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment: const Alignment(0.75, -0.95),
          child: Opacity(
            opacity: visible.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: 0.4 + 0.6 * pop,
              alignment: Alignment.bottomLeft,
              child: const _Bubble(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _BubblePainter(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
        child: Text(
          'Hallo!',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFF2E4A2A),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  const _BubblePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height - 8),
      const Radius.circular(16),
    );
    final tail = Path()
      ..moveTo(14, size.height - 10)
      ..lineTo(6, size.height)
      ..lineTo(28, size.height - 10)
      ..close();
    final shape = Path()
      ..addRRect(body)
      ..addPath(tail, Offset.zero);
    canvas
      ..drawShadow(shape, Colors.black, 3, false)
      ..drawPath(shape, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_BubblePainter old) => false;
}
