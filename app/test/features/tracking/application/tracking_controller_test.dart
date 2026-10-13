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
  var now = DateTime.utc(2026, 10, 13, 8, 5);

  ProviderContainer newContainer() {
    final c = ProviderContainer(
      overrides: [
        locationSourceProvider.overrideWithValue(location),
        recordedWalkRepositoryProvider.overrideWithValue(walks),
        walkClockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() {
    final db = testDatabase();
    addTearDown(db.close);
    location = FakeLocationSource();
    walks = DriftRecordedWalkRepository(db);
    now = DateTime.utc(2026, 10, 13, 8, 5);
    container = newContainer();
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

  Future<void> walkSixPointsThenKillApp() async {
    await controller().start();
    for (var i = 0; i < 6; i++) {
      location.emit(eastOf(i * 10.0, i * 10));
    }
    await Future<void>.delayed(Duration.zero);
    container.dispose();
  }

  Future<ProviderContainer> reopenApp() async {
    final reopened = newContainer()..read(trackingControllerProvider);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return reopened;
  }

  test('nach kurzem App-Ende läuft der Gang weiter', () async {
    await walkSixPointsThenKillApp();
    expect(await walks.pending(), isEmpty);

    final reopened = await reopenApp();
    final session = reopened.read(trackingControllerProvider);
    expect(session, isA<WalkRecording>());
    expect((session as WalkRecording).distanceMeters, closeTo(50, 1));

    location.emit(eastOf(80, 80));
    await Future<void>.delayed(Duration.zero);
    await reopened.read(trackingControllerProvider.notifier).stop();
    expect((await walks.pending()).single.points, hasLength(7));
  });

  test('nach langer Pause wird der Gang so abgeschlossen', () async {
    await walkSixPointsThenKillApp();
    now = now.add(const Duration(hours: 3));

    final reopened = await reopenApp();
    expect(reopened.read(trackingControllerProvider), isA<WalkIdle>());
    expect((await walks.pending()).single.points, hasLength(6));
    expect(await walks.unfinished(), isNull);
  });
}
