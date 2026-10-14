import 'dart:convert';

import 'package:meta/meta.dart';

/// Was ein Spieler von sich zeigt, als QR-Code. Kein Name, kein Ort: nur
/// eine zufällige Kennung, das Wesen und ein paar Zahlen.
@immutable
class FriendCard {
  const FriendCard({
    required this.player,
    required this.week,
    required this.at,
    this.species = '',
    this.level = 0,
    this.meters = 0,
    this.streets = 0,
    this.kinds = 0,
    this.weekMeters = 0,
    this.weekStreets = 0,
  });

  factory FriendCard.fromJson(Map<String, dynamic> j) => FriendCard(
    player: j['p'] as String,
    species: j['s'] as String? ?? '',
    level: j['l'] as int? ?? 0,
    meters: j['m'] as int? ?? 0,
    streets: j['n'] as int? ?? 0,
    kinds: j['k'] as int? ?? 0,
    week: j['w'] as String,
    weekMeters: j['wm'] as int? ?? 0,
    weekStreets: j['wn'] as int? ?? 0,
    at: DateTime.parse(j['a'] as String),
  );

  /// Zufällige Kennung, damit ein neuer Scan den alten Stand ersetzt.
  final String player;

  /// Art des aktuellen Wesens, leer für ein Ei.
  final String species;
  final int level;
  final int meters;
  final int streets;

  /// Wie viele Arten schon im Album sind.
  final int kinds;

  /// Montag der Woche, für die [weekMeters] und [weekStreets] gelten.
  final String week;
  final int weekMeters;
  final int weekStreets;
  final DateTime at;

  static const _prefix = 'wandoo:1:';

  /// Der Text im QR-Code.
  String encode() =>
      _prefix + base64Url.encode(utf8.encode(jsonEncode(toJson())));

  /// Liest einen QR-Text; null, wenn es kein Wandoo-Code ist.
  static FriendCard? decode(String text) {
    final code = text.trim();
    if (!code.startsWith(_prefix)) return null;
    try {
      final raw = utf8.decode(base64Url.decode(code.substring(_prefix.length)));
      return FriendCard.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  Map<String, Object?> toJson() => {
    'p': player,
    's': species,
    'l': level,
    'm': meters,
    'n': streets,
    'k': kinds,
    'w': week,
    'wm': weekMeters,
    'wn': weekStreets,
    'a': at.toIso8601String(),
  };
}

/// Montag der Woche von [day] als "2026-10-12".
String weekOf(DateTime day) {
  final monday = DateTime(day.year, day.month, day.day - (day.weekday - 1));
  String two(int n) => n.toString().padLeft(2, '0');
  return '${monday.year}-${two(monday.month)}-${two(monday.day)}';
}
