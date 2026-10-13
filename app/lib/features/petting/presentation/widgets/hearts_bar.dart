import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/petting/application/petting_providers.dart';
import 'package:wandoo/features/petting/domain/friendship.dart';
import 'package:wandoo/features/petting/presentation/widgets/heart_path.dart';

/// Fünf Herzen: so sehr mag dich dein Wesen. Das nächste füllt sich von
/// unten. Für Eier unsichtbar.
class HeartsBar extends ConsumerWidget {
  const HeartsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hatched = ref.watch(creatureProvider).value?.hatched ?? false;
    final friendship = ref.watch(friendshipProvider).value;
    if (!hatched || friendship == null) return const SizedBox.shrink();
    return Semantics(
      label: 'Freundschaft: ${friendship.hearts} von 5 Herzen',
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: CustomPaint(
          size: const Size(5 * 22, 20),
          painter: _HeartsPainter(
            friendship,
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }
}

class _HeartsPainter extends CustomPainter {
  _HeartsPainter(this.friendship, this.empty);

  final Friendship friendship;
  final Color empty;

  @override
  void paint(Canvas canvas, Size size) {
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = empty;
    final fill = Paint()..color = heartColor;
    for (var i = 0; i < Friendship.heartsAt.length; i++) {
      final heart = heartPath(Offset(11 + i * 22, size.height / 2), 17);
      final filled = i < friendship.hearts
          ? 1.0
          : i == friendship.hearts
          ? friendship.towardNext
          : 0.0;
      if (filled < 1) canvas.drawPath(heart, outline);
      if (filled <= 0) continue;
      final top = size.height * (1 - filled);
      canvas
        ..save()
        ..clipRect(Rect.fromLTRB(i * 22.0, top, i * 22.0 + 22, size.height))
        ..drawPath(heart, fill)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_HeartsPainter old) =>
      old.friendship.points != friendship.points || old.empty != empty;
}
