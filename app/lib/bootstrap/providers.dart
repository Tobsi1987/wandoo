import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/database_providers.dart';
import 'package:wandoo/core/map_data/empty_map_data_source.dart';
import 'package:wandoo/core/map_data/map_data_providers.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/drift_creature_repository.dart';
import 'package:wandoo/features/discovery/data/drift_known_segments_repository.dart';
import 'package:wandoo/features/discovery/discovery.dart';

/// Kompositionswurzel: Hier und nur hier werden Schnittstellen mit
/// Umsetzungen verbunden.
List<Override> appOverrides() {
  final db = AppDatabase.open();
  return [
    appDatabaseProvider.overrideWithValue(db),
    creatureRepositoryProvider.overrideWithValue(DriftCreatureRepository(db)),
    knownSegmentsRepositoryProvider.overrideWithValue(
      DriftKnownSegmentsRepository(db),
    ),
    mapDataSourceProvider.overrideWithValue(const EmptyMapDataSource()),
  ];
}
