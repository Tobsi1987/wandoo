import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/den/domain/build_furniture.dart';
import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/domain/room_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final roomRepositoryProvider = Provider<RoomRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final roomProvider = StreamProvider<DenRoom>(
  (ref) => ref.watch(roomRepositoryProvider).watch(),
);

final buildFurnitureProvider = Provider<BuildFurniture>(
  (ref) => BuildFurniture(
    rooms: ref.watch(roomRepositoryProvider),
    treasure: ref.watch(treasureRepositoryProvider),
  ),
);
