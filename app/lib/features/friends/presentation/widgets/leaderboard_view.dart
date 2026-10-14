import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/core/format/distance_label.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/friends/application/friends_providers.dart';
import 'package:wandoo/features/friends/domain/friend_card.dart';
import 'package:wandoo/features/friends/domain/leaderboard.dart';

/// Wer vorne liegt, wählbar nach Woche, Straßen oder Arten.
class LeaderboardView extends ConsumerStatefulWidget {
  const LeaderboardView({super.key});

  @override
  ConsumerState<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends ConsumerState<LeaderboardView> {
  Ranking _ranking = Ranking.weekKm;

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(myCardProvider);
    final friends = ref.watch(friendsProvider);
    if (me == null) return const Center(child: CircularProgressIndicator());
    final rows = rank(
      _ranking,
      me: me,
      friends: friends,
      week: weekOf(DateTime.now()),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final r in Ranking.values)
              ChoiceChip(
                key: Key('ranking-${r.name}'),
                label: Text(r.label),
                selected: r == _ranking,
                onSelected: (_) => setState(() => _ranking = r),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(_ranking.unit, style: Theme.of(context).textTheme.bodySmall),
        for (final row in rows) _row(context, row),
        if (friends.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'Noch allein hier. Unter Freunde kannst du Freunde '
              'hinzufügen, dann siehst du, wer vorne liegt.',
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _row(BuildContext context, LeaderRow row) {
    final colors = Theme.of(context).colorScheme;
    final species = row.card.species.isEmpty
        ? 'Ei'
        : SpeciesCatalog.byId(row.card.species).name;
    return Card(
      color: row.me ? colors.primaryContainer : null,
      child: ListTile(
        leading: Text(_medal(row.place), style: const TextStyle(fontSize: 26)),
        title: Text(row.name),
        subtitle: Text('$species · Level ${row.card.level}'),
        trailing: Text(
          _value(row.value),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  String _value(int v) => _ranking == Ranking.weekKm ? distanceLabel(v) : '$v';

  static String _medal(int place) => switch (place) {
    1 => '🥇',
    2 => '🥈',
    3 => '🥉',
    _ => '$place.',
  };
}
