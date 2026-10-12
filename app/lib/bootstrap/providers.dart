import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:wandoo/core/map_data/empty_map_data_source.dart';
import 'package:wandoo/core/map_data/map_data_providers.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/discovery/data/in_memory_known_segments_repository.dart';
import 'package:wandoo/features/discovery/discovery.dart';

/// Kompositionswurzel: Hier und nur hier werden Schnittstellen mit
/// Umsetzungen verbunden. Platzhalter werden später durch Drift- und
/// Plattform-Umsetzungen ersetzt.
List<Override> appOverrides() => [
  creatureRepositoryProvider.overrideWithValue(InMemoryCreatureRepository()),
  knownSegmentsRepositoryProvider.overrideWithValue(
    InMemoryKnownSegmentsRepository(),
  ),
  mapDataSourceProvider.overrideWithValue(const EmptyMapDataSource()),
];
