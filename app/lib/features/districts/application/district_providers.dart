import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/location/location_providers.dart';
import 'package:wandoo/core/map_data/map_data_providers.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/districts/domain/district.dart';
import 'package:wandoo/features/districts/domain/puzzle.dart';

/// Das Puzzle der Gegend, in der man gerade steht; `null` ohne Standort.
final FutureProvider<Puzzle?> puzzleProvider =
    FutureProvider.autoDispose<Puzzle?>((ref) async {
      final here = await ref.watch(locationSourceProvider).currentPosition();
      if (here == null) return null;
      final segments = await ref
          .watch(mapDataSourceProvider)
          .segmentsNear(_corners(here));
      final known = await ref.watch(_knownIdsProvider.future);
      return Puzzle.around(here, segments, known);
    });

final StreamProvider<Set<String>> _knownIdsProvider =
    StreamProvider.autoDispose<Set<String>>(
      (ref) => ref.watch(knownSegmentsRepositoryProvider).watchKnownIds(),
    );

/// Ecken der Puzzle-Gegend, damit alle Kartendaten dafür geladen werden.
List<GeoPoint> _corners(GeoPoint here) {
  const size = District.sizeDegrees * Puzzle.side;
  final south = (here.latitude / size).floor() * size;
  final west = (here.longitude / size).floor() * size;
  // Mehr als der Rand der Kartendaten, damit genau eine Kachel lädt.
  const inset = 0.0025;
  return [
    GeoPoint(south + inset, west + inset),
    GeoPoint(south + size - inset, west + size - inset),
  ];
}
