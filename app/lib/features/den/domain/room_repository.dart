import 'package:wandoo/features/den/domain/den_room.dart';

/// Speichert das eingerichtete Zuhause. Die Umsetzung liegt in `data/`.
abstract interface class RoomRepository {
  Future<DenRoom> load();

  Future<void> save(DenRoom room);

  Stream<DenRoom> watch();
}
