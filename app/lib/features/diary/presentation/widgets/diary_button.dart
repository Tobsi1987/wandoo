import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/diary/presentation/diary_screen.dart';

/// Öffnet das Wandertagebuch des Wesens: ein Buch-Knopf für die Leiste.
class DiaryButton extends StatelessWidget {
  const DiaryButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Tagebuch',
    padding: const EdgeInsets.all(4),
    onPressed: () => unawaited(context.push(DiaryScreen.path)),
    icon: const Icon(
      Icons.auto_stories_rounded,
      size: 32,
      color: Color(0xFF8A5A3C),
    ),
  );
}
