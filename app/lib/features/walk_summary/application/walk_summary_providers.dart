import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary_repository.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final walkSummaryRepositoryProvider = Provider<WalkSummaryRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

/// Die Zusammenfassung des letzten Gangs, bis sie weggeklickt wird.
final latestUnseenSummaryProvider = StreamProvider<WalkSummary?>(
  (ref) => ref.watch(walkSummaryRepositoryProvider).watchLatestUnseen(),
);
