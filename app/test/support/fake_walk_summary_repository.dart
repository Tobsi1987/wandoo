import 'package:wandoo/features/walk_summary/walk_summary.dart';

/// Merkt sich gespeicherte Zusammenfassungen in einer Liste.
class FakeWalkSummaryRepository implements WalkSummaryRepository {
  final List<WalkSummary> saved = [];

  @override
  Future<void> save(WalkSummary summary) async => saved.add(summary);

  @override
  Stream<WalkSummary?> watchLatestUnseen() => Stream.value(saved.lastOrNull);

  @override
  Future<void> markSeen(String walkId) async {}
}
