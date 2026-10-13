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
/// Viertel heißt immer gleich.
String districtName(District d) {
  final h = (d.row * 73856093) ^ (d.col * 19349663);
  final n = h & 0x7fffffff;
  return '${_first[n % _first.length]}'
      '${_second[(n ~/ _first.length) % _second.length]}';
}
