import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/districts/districts.dart';
import 'package:wandoo/features/districts/domain/district_streets.dart';

void main() {
  test('in einem Puzzle kommt kein Viertelname doppelt vor', () {
    for (final (row, col) in [(5000, 800), (5003, 801), (-42, -7), (0, 0)]) {
      final top = (row / 5).floor() * 5;
      final left = (col / 5).floor() * 5;
      final names = {
        for (var r = top; r < top + 5; r++)
          for (var c = left; c < left + 5; c++) districtName(District(r, c)),
      };
      expect(names, hasLength(25), reason: 'Block um ($row, $col)');
    }
  });

  test('Straßen eines Viertels: nach Name, mit bekanntem Anteil', () {
    RoadSegment seg(String id, String street, double lon) => RoadSegment(
      id: id,
      start: GeoPoint(50, lon),
      end: GeoPoint(50, lon + 0.001),
      streetId: street,
    );
    final streets = DistrictStreets(
      [
        seg('a', 'Lindenweg', 8),
        seg('b', 'Lindenweg', 8.001),
        seg('c', 'Amselstraße', 8.002),
        seg('d', 'w4711', 8.003),
      ],
      {'a', 'c'},
    );
    expect(streets.named.map((s) => s.name), ['Amselstraße', 'Lindenweg']);
    expect(streets.named.first.done, isTrue);
    expect(streets.named.last.percent, 50);
    expect(streets.unnamedMeters, greaterThan(50));
  });
}
