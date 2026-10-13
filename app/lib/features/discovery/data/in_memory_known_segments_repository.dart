import 'dart:async';

import 'package:wandoo/features/discovery/domain/known_segments_repository.dart';

/// Hält bekannte Abschnitte nur im Speicher. Für Tests und die Demo.
class InMemoryKnownSegmentsRepository implements KnownSegmentsRepository {
  final Set<String> _ids = {};
  final _changes = StreamController<Set<String>>.broadcast();

  @override
  Future<Set<String>> knownIds() async => Set.of(_ids);

  @override
  Future<void> addAll(Set<String> ids) async {
    _ids.addAll(ids);
    _changes.add(Set.of(_ids));
  }

  @override
  Stream<Set<String>> watchKnownIds() async* {
    yield Set.of(_ids);
    yield* _changes.stream;
  }
}
