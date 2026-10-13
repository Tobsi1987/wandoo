import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';

/// Formuliert eine Zusammenfassung in kurzen Zeilen, z. B.
/// "+3 neue Straßen", "1 Waldstück", "1 Brücke".
List<String> summaryLines(WalkSummary summary) {
  if (summary.foundNothing) {
    return const ['Nichts Neues dabei. Probier mal eine andere Abzweigung!'];
  }
  final streets = summary.newStreetCount;
  return [
    '+$streets ${streets == 1 ? 'neue Straße' : 'neue Straßen'}',
    for (final type in _order)
      if ((summary.streetsByEnvironment[type] ?? 0) > 0)
        _environmentLine(type, summary.streetsByEnvironment[type]!),
    if (summary.bridgeCount > 0) _bridgeLine(summary.bridgeCount),
    if (summary.creatureGrew) 'Dein Wesen ist gewachsen!',
  ];
}

String _bridgeLine(int n) => '$n ${n == 1 ? 'Brücke' : 'Brücken'}';

const List<EnvironmentType> _order = [
  EnvironmentType.forest,
  EnvironmentType.water,
  EnvironmentType.field,
  EnvironmentType.city,
];

String _environmentLine(EnvironmentType type, int n) {
  final (one, many) = switch (type) {
    EnvironmentType.forest => ('Waldstück', 'Waldstücke'),
    EnvironmentType.water => ('Weg am Wasser', 'Wege am Wasser'),
    EnvironmentType.field => ('Feldweg', 'Feldwege'),
    EnvironmentType.city => ('Stadtstraße', 'Stadtstraßen'),
    EnvironmentType.unknown => ('Weg', 'Wege'),
  };
  return '$n ${n == 1 ? one : many}';
}
