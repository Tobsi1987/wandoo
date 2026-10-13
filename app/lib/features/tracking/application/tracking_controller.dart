import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/location/location_providers.dart';
import 'package:wandoo/features/tracking/application/tracking_providers.dart';
import 'package:wandoo/features/tracking/domain/walk_recorder.dart';
import 'package:wandoo/features/tracking/domain/walk_session.dart';

/// Startet und beendet die Aufzeichnung eines Gangs.
class TrackingController extends Notifier<WalkSession> {
  StreamSubscription<TrackPoint>? _subscription;
  WalkRecorder? _recorder;

  @override
  WalkSession build() {
    ref.onDispose(() => _subscription?.cancel());
    return const WalkIdle();
  }

  Future<void> start() async {
    if (state is WalkRecording) return;
    final location = ref.read(locationSourceProvider);
    if (!await location.ensurePermission()) {
      state = const WalkIdle(permissionDenied: true);
      return;
    }
    final startedAt = DateTime.now();
    final recorder = WalkRecorder(id: 'walk-${startedAt.toIso8601String()}');
    _recorder = recorder;
    state = WalkRecording(startedAt: startedAt, distanceMeters: 0);
    _subscription = location.positions().listen((point) {
      recorder.add(point);
      state = WalkRecording(
        startedAt: startedAt,
        distanceMeters: recorder.distanceMeters,
      );
    });
  }

  /// Beendet den Gang und legt ihn zur Verarbeitung ab.
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    final recorder = _recorder;
    _recorder = null;
    state = const WalkIdle();
    if (recorder == null || !recorder.hasWalk) return;
    await ref
        .read(recordedWalkRepositoryProvider)
        .saveFinished(recorder.finish());
  }
}
