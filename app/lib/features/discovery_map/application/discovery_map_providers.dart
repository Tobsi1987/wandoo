import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/location/location_providers.dart';
import 'package:wandoo/core/map_data/map_data_providers.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/discovery_map/domain/discovery_overview.dart';

/// Ob unter den Straßen die OSM-Karte liegt. Die Demo schaltet sie ab,
/// weil ihre Stadt erfunden ist.
final Provider<bool> showBaseMapProvider = Provider<bool>((ref) => true);

/// Wo die Karte steht: aktuelle Position, `null` ohne Standort.
final FutureProvider<GeoPoint?> mapCenterProvider =
    FutureProvider.autoDispose<GeoPoint?>(
      (ref) => ref.watch(locationSourceProvider).currentPosition(),
    );

/// Abschnitte rund um den Kartenmittelpunkt (lädt die Kachel bei Bedarf).
final FutureProviderFamily<List<RoadSegment>, GeoPoint> _segmentsProvider =
    FutureProvider.autoDispose.family<List<RoadSegment>, GeoPoint>(
      (ref, center) => ref.watch(mapDataSourceProvider).segmentsNear([center]),
    );

final StreamProvider<Set<String>> _knownIdsProvider =
    StreamProvider.autoDispose<Set<String>>(
      (ref) => ref.watch(knownSegmentsRepositoryProvider).watchKnownIds(),
    );

/// Alles für die Entdeckungskarte, aktualisiert sich nach jedem Gang.
final FutureProvider<DiscoveryOverview?> discoveryOverviewProvider =
    FutureProvider.autoDispose<DiscoveryOverview?>((ref) async {
      final center = await ref.watch(mapCenterProvider.future);
      if (center == null) return null;
      final segments = await ref.watch(_segmentsProvider(center).future);
      final known = await ref.watch(_knownIdsProvider.future);
      return DiscoveryOverview(
        center: center,
        segments: segments,
        knownIds: known,
      );
    });
