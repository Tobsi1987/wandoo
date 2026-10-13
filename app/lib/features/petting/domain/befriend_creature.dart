import 'package:wandoo/features/petting/domain/friendship.dart';

/// Regeln, wie die Freundschaft wächst: Streicheln zählt ein paar Mal am
/// Tag, gemeinsame Gänge zählen immer. So lohnt sich Rausgehen am meisten.
class BefriendCreature {
  const BefriendCreature({
    this.perPet = 1,
    this.petsPerDay = 5,
    this.perWalk = 3,
  });

  final int perPet;
  final int petsPerDay;
  final int perWalk;

  /// Streicheln; über [petsPerDay] hinaus freut es sich nur noch.
  Friendship pet(Friendship f, DateTime now) {
    final day = DateTime(now.year, now.month, now.day);
    final today = f.petDay == day ? f.petsToday : 0;
    if (today >= petsPerDay) return f.copyWith(petsToday: today, petDay: day);
    return f.copyWith(
      points: f.points + perPet,
      petsToday: today + 1,
      petDay: day,
    );
  }

  /// Ein gemeinsamer Gang.
  Friendship walked(Friendship f) => f.copyWith(points: f.points + perWalk);
}
