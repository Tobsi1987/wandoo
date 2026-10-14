import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/diary/diary.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

/// Schreibt jeden Gang ins Tagebuch des Wesens, mit den Momenten, an die
/// man sich erinnern will. Runde Kilometer stehen auch in der
/// Zusammenfassung.
class DiaryExtra implements WalkExtra {
  const DiaryExtra(this.diaries, {this.remember = const RememberWalk()});

  final DiaryRepository diaries;
  final RememberWalk remember;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    final before = outcome.before;
    final after = outcome.after;
    final key = after.lineKey;
    final diary = await diaries.load(key);
    final facts = WalkFacts(
      walkId: outcome.track.id,
      creatureKey: key,
      finishedAt: outcome.summary.finishedAt,
      track: outcome.track.positions,
      metersBefore: before.walkedMeters,
      metersAfter: after.walkedMeters,
      firstWalk: diary.walks.isEmpty,
      withEgg: !before.hatched,
      hatched: !before.hatched && after.hatched,
      grewTo: before.hatched && after.stage != before.stage
          ? stageLabel(after.stage)
          : null,
    );
    final memories = remember.memories(facts);
    await diaries.add(remember.walk(facts), memories);
    return [
      for (final m in memories)
        if (m.emoji == '🏅') '${m.emoji} ${m.title}',
    ];
  }
}
