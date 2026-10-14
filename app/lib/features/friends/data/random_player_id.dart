import 'dart:math';

/// Eine zufällige Kennung aus 10 Zeichen, die nichts über den Spieler sagt.
String randomPlayerId([Random? random]) {
  final r = random ?? Random.secure();
  const letters = 'abcdefghijkmnpqrstuvwxyz23456789';
  return String.fromCharCodes([
    for (var i = 0; i < 10; i++) letters.codeUnitAt(r.nextInt(letters.length)),
  ]);
}
