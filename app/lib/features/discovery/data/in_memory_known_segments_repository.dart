import 'package:wandoo/features/discovery/domain/known_segments_repository.dart';

/// Hält bekannte Abschnitte nur im Speicher. Für Tests.
class InMemoryKnownSegmentsRepository implements KnownSegmentsRepository {
  final Set<String> _ids = {};

  @override
  Future<Set<String>> knownIds() async => Set.of(_ids);

  @override
  Future<void> addAll(Set<String> ids) async => _ids.addAll(ids);

  @override
  Stream<Set<String>> watchKnownIds() => Stream.value(Set.of(_ids));
}
