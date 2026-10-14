import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/diary/presentation/diary_screen.dart';

/// Öffnet das Wandertagebuch des Wesens.
class DiaryButton extends StatelessWidget {
  const DiaryButton({super.key});

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: () => unawaited(context.push(DiaryScreen.path)),
    icon: const Icon(Icons.menu_book_outlined),
    label: const Text('Tagebuch'),
  );
}
