import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/core/location/location_providers.dart';
import 'package:wandoo/features/tracking/application/tracking_controller.dart';
import 'package:wandoo/features/tracking/data/drift_recorded_walk_repository.dart';
import 'package:wandoo/features/tracking/tracking.dart';

import '../../../support/fake_location_source.dart';
import '../../../support/test_database.dart';

void main() {
  late FakeLocationSource location;
  late ProviderContainer container;
  late RecordedWalkRepository walks;

  setUp(() {
    final db = testDatabase();
    addTearDown(db.close);
    location = FakeLocationSource();
    walks = DriftRecordedWalkRepository(db);
    container = ProviderContainer(
      overrides: [
        locationSourceProvider.overrideWithValue(location),
        recordedWalkRepositoryProvider.overrideWithValue(walks),
      ],
    );
    addTearDown(container.dispose);
  });

  TrackingController controller() =>
      container.read(trackingControllerProvider.notifier);

  test('Gang aufzeichnen und zur Verarbeitung ablegen', () async {
    await controller().start();
    location
      ..emit(eastOf(0, 0))
      ..emit(eastOf(30, 20));
    await Future<void>.delayed(Duration.zero);
    final session = container.read(trackingControllerProvider);
    expect(session, isA<WalkRecording>());
    expect((session as WalkRecording).distanceMeters, closeTo(30, 1));

    await controller().stop();
    expect(container.read(trackingControllerProvider), isA<WalkIdle>());
    expect((await walks.pending()).single.points, hasLength(2));
  });

  test('ohne Freigabe startet nichts', () async {
    location.granted = false;
    await controller().start();
    final session = container.read(trackingControllerProvider);
    expect(session, isA<WalkIdle>());
    expect((session as WalkIdle).permissionDenied, isTrue);
  });

  test('Gang ohne Bewegung wird nicht gespeichert', () async {
    await controller().start();
    location.emit(eastOf(0, 0));
    await Future<void>.delayed(Duration.zero);
    await controller().stop();
    expect(await walks.pending(), isEmpty);
  });
}
