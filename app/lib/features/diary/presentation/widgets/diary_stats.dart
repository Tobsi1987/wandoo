import 'package:flutter/material.dart';
import 'package:wandoo/core/format/distance_label.dart';
import 'package:wandoo/features/diary/domain/diary.dart';
import 'package:wandoo/features/diary/presentation/diary_labels.dart';

/// Drei Zahlen oben im Tagebuch: Gänge, Strecke, seit wann.
class DiaryStats extends StatelessWidget {
  const DiaryStats({required this.diary, super.key});

  final Diary diary;

  @override
  Widget build(BuildContext context) {
    final walks = diary.walks.length;
    final since = diary.since;
    return Row(
      children: [
        _Stat('👣', walks == 1 ? '1 Gang' : '$walks Gänge'),
        _Stat('📏', distanceLabel(diary.meters)),
        if (since != null) _Stat('📅', 'seit ${dateLabel(since)}'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.emoji, this.text);

  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    ),
  );
}
