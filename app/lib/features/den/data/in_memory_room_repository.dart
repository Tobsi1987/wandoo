import 'dart:async';

import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/domain/room_repository.dart';

/// Für Tests und die Demo.
class InMemoryRoomRepository implements RoomRepository {
  InMemoryRoomRepository([this._room = const DenRoom()]);

  DenRoom _room;
  final _changes = StreamController<DenRoom>.broadcast();

  @override
  Future<DenRoom> load() async => _room;

  @override
  Future<void> save(DenRoom room) async => _changes.add(_room = room);

  @override
  Stream<DenRoom> watch() async* {
    yield _room;
    yield* _changes.stream;
  }
}
