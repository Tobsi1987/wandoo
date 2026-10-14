import 'dart:async';

import 'package:wandoo/features/star_catch/domain/star_catch_repository.dart';

/// Für Tests und die Demo.
class InMemoryStarCatchRepository implements StarCatchRepository {
  String? _walk;
  final _changes = StreamController<String?>.broadcast();

  @override
  Future<String?> lastWalk() async => _walk;

  @override
  Future<void> playedAfter(String walkId) async {
    _walk = walkId;
    _changes.add(walkId);
  }

  @override
  Stream<String?> watchLastWalk() async* {
    yield _walk;
    yield* _changes.stream;
  }
}
