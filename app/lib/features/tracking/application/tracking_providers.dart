import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/tracking/application/tracking_controller.dart';
import 'package:wandoo/features/tracking/domain/recorded_walk_repository.dart';
import 'package:wandoo/features/tracking/domain/walk_session.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final recordedWalkRepositoryProvider = Provider<RecordedWalkRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

/// Anzahl der Gänge, die noch verarbeitet werden müssen.
final pendingWalkCountProvider = StreamProvider<int>(
  (ref) => ref.watch(recordedWalkRepositoryProvider).watchPendingCount(),
);

final trackingControllerProvider =
    NotifierProvider<TrackingController, WalkSession>(TrackingController.new);
