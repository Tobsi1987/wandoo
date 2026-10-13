import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/location/location_providers.dart';
import 'package:wandoo/core/map_data/map_data_providers.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';
import 'package:wandoo/features/discovery/data/in_memory_known_segments_repository.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/districts/districts.dart';

import '../../../support/fake_location_source.dart';

class _Street implements MapDataSource {
  @override
  Future<List<RoadSegment>> segmentsNear(List<GeoPoint> points) async => [
    for (var i = 0; i < 10; i++)
      RoadSegment(
        id: 's$i',
        start: GeoPoint(50.005, 8 + i * 0.001),
        end: GeoPoint(50.005, 8 + (i + 1) * 0.001),
      ),
  ];
}

void main() {
  testWidgets('zeigt 25 Teile, das eigene Viertel und das Abzeichen', (
    tester,
  ) async {
    final known = InMemoryKnownSegmentsRepository();
    await known.addAll({for (var i = 0; i < 8; i++) 's$i'});
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationSourceProvider.overrideWithValue(
            FakeLocationSource(current: const GeoPoint(50.004, 8.002)),
          ),
          mapDataSourceProvider.overrideWithValue(_Street()),
          knownSegmentsRepositoryProvider.overrideWithValue(known),
        ],
        child: const MaterialApp(home: PuzzleScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1 von 1 Teilen gelegt'), findsOneWidget);
    expect(find.text('Wildnis'), findsNWidgets(24));
    expect(find.text('📍'), findsOneWidget);
    expect(find.text('Geschafft'), findsOneWidget);
  });
}
