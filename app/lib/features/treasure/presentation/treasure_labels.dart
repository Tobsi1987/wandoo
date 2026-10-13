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

/// "🌰 2 Eicheln", "🐚 1 Muschel" – je Fundstück eine Zeile für die
/// Zusammenfassung.
List<String> foundLines(List<Find> found) {
  final counts = <Find, int>{};
  for (final f in found) {
    counts.update(f, (n) => n + 1, ifAbsent: () => 1);
  }
  return [
    for (final e in counts.entries)
      '${findEmoji(e.key)} ${e.value} ${_name(e.key, e.value)}',
  ];
}

String _name(Find f, int count) =>
    count == 1 ? findNames(f).$1 : findNames(f).$2;
