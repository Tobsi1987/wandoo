import 'package:wandoo/features/discovery/domain/known_segments_repository.dart';

/// Platzhalter, bis die Drift-Datenbank in `core/database/` steht.
class InMemoryKnownSegmentsRepository implements KnownSegmentsRepository {
  final Set<String> _ids = {};

  @override
  Future<Set<String>> knownIds() async => Set.of(_ids);

  @override
  Future<void> addAll(Set<String> ids) async => _ids.addAll(ids);
}
