import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/den/data/in_memory_room_repository.dart';
import 'package:wandoo/features/den/data/room_json.dart';
import 'package:wandoo/features/den/domain/build_furniture.dart';
import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/domain/furniture.dart';
import 'package:wandoo/features/treasure/data/in_memory_treasure_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';

void main() {
  test('jeder Platz hat drei Möbel', () {
    for (final spot in Spot.values) {
      expect(Furniture.at(spot), hasLength(3));
    }
  });

  test('neues Möbel steht sofort, ein anderes tauscht es aus', () {
    var room = const DenRoom().add(Furniture.hayNest);
    expect(room.at(Spot.bed), Furniture.hayNest);
    room = room.add(Furniture.shellBed);
    expect(room.at(Spot.bed), Furniture.shellBed);
    room = room.put(Furniture.hayNest);
    expect(room.at(Spot.bed), Furniture.hayNest);
    expect(room.owned, {Furniture.hayNest, Furniture.shellBed});
    expect(room.clear(Spot.bed).at(Spot.bed), isNull);
    expect(const DenRoom().put(Furniture.fern).at(Spot.plant), isNull);
  });

  test('JSON hin und zurück', () {
    final room = const DenRoom().add(Furniture.fern).add(Furniture.ball);
    final back = roomFromJson(roomToJson(room));
    expect(back.owned, room.owned);
    expect(back.placed, room.placed);
    expect(
      roomFromJson({
        'owned': ['gibtsnicht'],
        'placed': 3,
      }).owned,
      isEmpty,
    );
  });

  test('Bauen kostet Fundstücke und klappt nur einmal', () async {
    final treasure = InMemoryTreasureRepository(
      const TreasureChest(finds: {Find.poppy: 4}),
    );
    final rooms = InMemoryRoomRepository();
    final build = BuildFurniture(rooms: rooms, treasure: treasure);
    expect(await build(Furniture.flowerPot), isTrue);
    expect((await treasure.load()).count(Find.poppy), 1);
    expect((await rooms.load()).at(Spot.plant), Furniture.flowerPot);
    expect(await build(Furniture.flowerPot), isFalse);
    expect(await build(Furniture.fern), isFalse);
  });
}
