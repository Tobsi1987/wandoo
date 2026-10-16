import 'package:wandoo/features/districts/domain/district.dart';

const _first = [
  'Sonnen',
  'Moos',
  'Funkel',
  'Igel',
  'Pusteblumen',
  'Eichhörnchen',
  'Wolken',
  'Kastanien',
  'Löwenzahn',
  'Regenbogen',
  'Hummel',
  'Glühwürmchen',
  'Kleeblatt',
  'Schnecken',
  'Apfel',
  'Zauber',
];

const _second = [
  'winkel',
  'grund',
  'hügel',
  'eck',
  'tal',
  'au',
  'hain',
  'nest',
];

/// Kinderfreundlicher Name eines Viertels, z. B. "Igelhügel". Dasselbe
/// Viertel heißt immer gleich, und in einem Puzzle (5 × 5 Viertel) kommt
/// kein Name doppelt vor.
String districtName(District d) {
  final blockRow = (d.row / _block).floor();
  final blockCol = (d.col / _block).floor();
  final index =
      (d.row - blockRow * _block) * _block + d.col - blockCol * _block;
  final seed = _mix(blockRow * 31 + blockCol);
  // Ungerader Schritt: Bei 128 Namen trifft jeder der 25 Plätze einen
  // anderen Namen.
  final step = (seed >> 7) | 1;
  final n = (seed + index * step) % (_first.length * _second.length);
  return '${_first[n % _first.length]}${_second[n ~/ _first.length]}';
}

const _block = 5;

/// Verteilt benachbarte Zahlen gut über alle Bits (positiv, 31 Bit).
int _mix(int x) {
  var h = (x * 0x45d9f3b) & 0x7fffffff;
  h = ((h >> 16) ^ h) * 0x45d9f3b & 0x7fffffff;
  return (h >> 16) ^ h;
}
