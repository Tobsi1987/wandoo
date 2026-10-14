import 'package:wandoo/core/memory/memory_value.dart';
import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/domain/room_repository.dart';

/// Für Tests und die Demo.
class InMemoryRoomRepository extends MemoryValue<DenRoom>
    implements RoomRepository {
  InMemoryRoomRepository([super.value = const DenRoom()]);
}
