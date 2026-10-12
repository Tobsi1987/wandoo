import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/discovery/domain/discover_segments.dart';
import 'package:wandoo/features/discovery/domain/known_segments_repository.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final knownSegmentsRepositoryProvider = Provider<KnownSegmentsRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final discoverSegmentsProvider = Provider<DiscoverSegments>(
  (ref) =>
      DiscoverSegments(repository: ref.watch(knownSegmentsRepositoryProvider)),
);
