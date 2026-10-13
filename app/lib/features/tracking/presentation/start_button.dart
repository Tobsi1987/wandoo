import 'package:flutter/material.dart';

/// Der große runde Knopf zum Losgehen: gemalt (Midjourney), mit dem Wort
/// darunter.
class StartButton extends StatelessWidget {
  const StartButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: 'Losgehen',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/ui/start.png', width: 84, height: 84),
            Text(
              'Losgehen',
              style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: const [Shadow(blurRadius: 6)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
