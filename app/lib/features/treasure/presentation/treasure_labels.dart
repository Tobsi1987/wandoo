import 'package:wandoo/features/treasure/domain/accessory.dart';
import 'package:wandoo/features/treasure/domain/find.dart';

/// Name eines Fundstücks, Einzahl und Mehrzahl.
(String, String) findNames(Find f) => switch (f) {
  Find.acorn => ('Eichel', 'Eicheln'),
  Find.shell => ('Muschel', 'Muscheln'),
  Find.sparkle => ('Glitzerstein', 'Glitzersteine'),
  Find.poppy => ('Mohnblume', 'Mohnblumen'),
  Find.starShard => ('Sternsplitter', 'Sternsplitter'),
};

String findEmoji(Find f) => switch (f) {
  Find.acorn => '🌰',
  Find.shell => '🐚',
  Find.sparkle => '💎',
  Find.poppy => '🌺',
  Find.starShard => '⭐',
};

String accessoryName(Accessory a) => switch (a) {
  Accessory.acornCap => 'Eichelhütchen',
  Accessory.flowerCrown => 'Blütenkranz',
  Accessory.starCrown => 'Sternenkrone',
  Accessory.shellNecklace => 'Muschelkette',
  Accessory.sparkleScarf => 'Glitzerschal',
};

/// "Gefunden: 2 Eicheln, 1 Muschel" – Zeile für die Zusammenfassung.
String? foundLine(List<Find> found) {
  if (found.isEmpty) return null;
  final counts = <Find, int>{};
  for (final f in found) {
    counts.update(f, (n) => n + 1, ifAbsent: () => 1);
  }
  final parts = [
    for (final e in counts.entries)
      '${e.value} ${e.value == 1 ? findNames(e.key).$1 : findNames(e.key).$2}',
  ];
  return 'Gefunden: ${parts.join(', ')}';
}
