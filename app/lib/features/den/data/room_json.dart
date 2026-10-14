import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/domain/furniture.dart';

Map<String, Object> roomToJson(DenRoom room) => {
  'owned': [for (final f in room.owned) f.name],
  'placed': [for (final f in room.placed.values) f.name],
};

DenRoom roomFromJson(Map<String, dynamic> json) {
  final byName = Furniture.values.asNameMap();
  Iterable<Furniture> list(Object? names) => [
    if (names is List)
      for (final n in names) ?byName[n],
  ];
  final owned = list(json['owned']).toSet();
  return DenRoom(
    owned: owned,
    placed: {
      for (final f in list(json['placed']))
        if (owned.contains(f)) f.spot: f,
    },
  );
}
