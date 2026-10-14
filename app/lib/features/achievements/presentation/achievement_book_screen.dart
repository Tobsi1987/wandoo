import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/achievements/application/achievement_providers.dart';
import 'package:wandoo/features/achievements/domain/achievement.dart';
import 'package:wandoo/features/achievements/domain/achievement_catalog.dart';
import 'package:wandoo/features/achievements/presentation/widgets/stamp_tile.dart';

/// Das Erfolge-Buch: Seite für Seite Stempel in Bronze, Silber und Gold.
/// Es gibt nichts dafür; es zeigt nur, was man zusammen erlebt hat.
class AchievementBookScreen extends ConsumerWidget {
  const AchievementBookScreen({super.key});

  static const path = '/erfolge';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputs = ref.watch(achievementInputsProvider);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Erfolge-Buch')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _Tally(inputs: inputs),
          for (final page in AchievementCatalog.pages) ...[
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 8),
              child: Text(
                page.title,
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 160,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final a in page.achievements)
                  StampTile(achievement: a, inputs: inputs),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Oben: wie viele Stempel man schon hat, nach Farbe.
class _Tally extends StatelessWidget {
  const _Tally({required this.inputs});

  final AchievementInputs inputs;

  @override
  Widget build(BuildContext context) {
    final tiers = [for (final a in AchievementCatalog.all) a.tierFor(inputs)];
    int count(Tier t) => tiers.where((x) => x.index >= t.index).length;
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final t in [Tier.bronze, Tier.silver, Tier.gold])
              Expanded(
                child: Column(
                  children: [
                    StampMedal(tier: t, size: 26),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${count(t)} von ${tiers.length}',
                        style: text.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
