import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/location/location_providers.dart';
import 'package:wandoo/features/tracking/application/tracking_providers.dart';
import 'package:wandoo/features/tracking/domain/unfinished_walk.dart';
import 'package:wandoo/features/tracking/domain/walk_recorder.dart';
import 'package:wandoo/features/tracking/domain/walk_session.dart';

/// Startet und beendet die Aufzeichnung eines Gangs.
///
/// Der laufende Gang wird alle paar Punkte gesichert. Wird die App mitten
/// im Gang beendet, setzt der nächste Start ihn fort oder schließt ihn ab.
class TrackingController extends Notifier<WalkSession> {
  /// Nach so vielen neuen Punkten wird zwischengesichert.
  static const saveEvery = 6;

  StreamSubscription<TrackPoint>? _subscription;
  WalkRecorder? _recorder;
  int _savedPoints = 0;

  @override
  WalkSession build() {
    ref.onDispose(() => _subscription?.cancel());
    unawaited(_restore());
    return const WalkIdle();
  }

  Future<void> start() async {
    if (state is WalkRecording) return;
    final now = ref.read(walkClockProvider)();
    await _record(WalkRecorder(id: 'walk-${now.toIso8601String()}'), now);
  }

  /// Beendet den Gang und legt ihn zur Verarbeitung ab.
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    final recorder = _recorder;
    _recorder = null;
    state = const WalkIdle();
    if (recorder == null) return;
    final walks = ref.read(recordedWalkRepositoryProvider);
    if (recorder.hasWalk) {
      await walks.saveFinished(recorder.finish());
    } else {
      await walks.discard(recorder.id);
    }
  }

  Future<void> _restore() async {
    final walks = ref.read(recordedWalkRepositoryProvider);
    final track = await walks.unfinished();
    if (track == null || state is WalkRecording) return;
    final now = ref.read(walkClockProvider)();
    switch (const UnfinishedWalkPolicy().decide(track, now)) {
      case UnfinishedWalkAction.resume:
        final startedAt = track.startedAt ?? now;
        await _record(WalkRecorder.resume(track), startedAt);
        if (state is! WalkRecording) await walks.saveFinished(track);
      case UnfinishedWalkAction.finish:
        await walks.saveFinished(track);
      case UnfinishedWalkAction.discard:
        await walks.discard(track.id);
    }
  }

  Future<void> _record(WalkRecorder recorder, DateTime startedAt) async {
    final location = ref.read(locationSourceProvider);
    if (!await location.ensurePermission()) {
      state = const WalkIdle(permissionDenied: true);
      return;
    }
    _recorder = recorder;
    _savedPoints = recorder.pointCount;
    _publish(recorder, startedAt);
    _subscription = location.positions().listen((point) {
      recorder.add(point);
      _publish(recorder, startedAt);
      _saveProgressIfDue(recorder);
    });
  }

  void _publish(WalkRecorder recorder, DateTime startedAt) =>
      state = WalkRecording(
        startedAt: startedAt,
        distanceMeters: recorder.distanceMeters,
        tooFast: recorder.tooFast,
        position: recorder.position,
        cameFrom: recorder.cameFrom(),
      );

  void _saveProgressIfDue(WalkRecorder recorder) {
    if (recorder.pointCount - _savedPoints < saveEvery) return;
    _savedPoints = recorder.pointCount;
    unawaited(
      ref.read(recordedWalkRepositoryProvider).saveProgress(recorder.finish()),
    );
  }
}
