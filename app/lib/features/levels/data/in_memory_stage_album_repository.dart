import 'dart:async';
import 'dart:math';

import 'package:wandoo/features/levels/domain/stage_album_repository.dart';

/// Für Tests und die Demo.
class InMemoryStageAlbumRepository implements StageAlbumRepository {
  InMemoryStageAlbumRepository([Map<String, int> start = const {}])
    : _all = {...start};

  final Map<String, int> _all;
  final _changes = StreamController<Map<String, int>>.broadcast();

  @override
  Stream<Map<String, int>> watch() async* {
    yield {..._all};
    yield* _changes.stream;
  }

  @override
  Future<void> reach(String speciesId, int stage) async {
    _all[speciesId] = max(_all[speciesId] ?? 1, stage);
    _changes.add({..._all});
  }
}
