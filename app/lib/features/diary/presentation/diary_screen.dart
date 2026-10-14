import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/diary/application/diary_providers.dart';
import 'package:wandoo/features/diary/domain/diary.dart';
import 'package:wandoo/features/diary/presentation/widgets/diary_map.dart';
import 'package:wandoo/features/diary/presentation/widgets/diary_stats.dart';
import 'package:wandoo/features/diary/presentation/widgets/memory_tile.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';

/// Das Wandertagebuch: alle Wege des Wesens auf einer Karte, dazu die
/// schönsten Momente.
class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({this.footer, super.key});

  static const path = '/tagebuch';

  /// Leiste ganz unten, vom Router eingehängt (Teilen, Wegschicken).
  final Widget? footer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creature = ref.watch(creatureProvider).value;
    final name = creature != null && creature.hatched
        ? 'von ${SpeciesCatalog.byId(creature.speciesId).name}'
        : 'deines Eis';
    return Scaffold(
      appBar: AppBar(title: Text('Tagebuch $name')),
      bottomNavigationBar: footer,
      body: ref
          .watch(diaryProvider)
          .when(
            data: (diary) => diary.isEmpty
                ? const _Empty()
                : _content(diary, ref.watch(showBaseMapProvider)),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => const _Empty(),
          ),
    );
  }

  Widget _content(Diary diary, bool baseMap) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      DiaryStats(diary: diary),
      const SizedBox(height: 16),
      if (diary.walks.isNotEmpty)
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 300,
            child: DiaryMap(diary: diary, showBaseMap: baseMap),
          ),
        ),
      const SizedBox(height: 16),
      for (final memory in diary.memories.reversed) MemoryTile(memory: memory),
    ],
  );
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Noch keine Einträge. Geht zusammen los, dann füllt sich euer '
        'Tagebuch mit Wegen und Erinnerungen.',
        textAlign: TextAlign.center,
      ),
    ),
  );
}
