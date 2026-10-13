import 'package:flutter/material.dart';
import 'package:wandoo/features/diary/domain/diary.dart';
import 'package:wandoo/features/diary/presentation/diary_labels.dart';

/// Eine Erinnerung in der Liste unter der Karte.
class MemoryTile extends StatelessWidget {
  const MemoryTile({required this.memory, super.key});

  final Memory memory;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      child: Text(memory.emoji, style: const TextStyle(fontSize: 20)),
    ),
    title: Text(memory.title),
    subtitle: Text(dateLabel(memory.at)),
  );
}
