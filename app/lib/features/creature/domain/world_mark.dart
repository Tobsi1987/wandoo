import 'package:meta/meta.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/trait.dart';

/// Die Spur, die die Welt am Wesen hinterlässt: Wer viele neue Waldwege
/// geht, bekommt Moos, am Wasser Schuppen, auf dem Feld Blumen, in der
/// Stadt kleine Lichter. Es zählt die Umgebung mit den meisten neuen
/// Wegen; die Spur wächst in drei Stufen.
@immutable
class WorldMark {
  const WorldMark(this.trait, this.level);

  final Trait trait;

  /// 1 = ein kleiner Fleck, 3 = die ganze Spur.
  final int level;

  /// Neue Abschnitte in einer Umgebung, ab denen die Stufen beginnen.
  static const steps = [10, 40, 100];

  /// Die Spur von [creature]; Eier und frisch Geschlüpfte haben keine.
  static WorldMark? of(Creature creature) {
    if (!creature.hatched) return null;
    final trait = creature.dominantTrait;
    if (trait == null) return null;
    final points = creature.traitPoints[trait] ?? 0;
    final level = steps.where((s) => points >= s).length;
    return level == 0 ? null : WorldMark(trait, level);
  }

  @override
  bool operator ==(Object other) =>
      other is WorldMark && other.trait == trait && other.level == level;

  @override
  int get hashCode => Object.hash(trait, level);
}
