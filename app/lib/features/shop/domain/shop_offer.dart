import 'package:meta/meta.dart';

/// Etwas, das man im Laden kaufen kann. Was es tut, steckt in [buy];
/// der Laden selbst kennt die anderen Teile der App nicht.
@immutable
class ShopOffer {
  const ShopOffer({
    required this.id,
    required this.emoji,
    required this.title,
    required this.text,
    required this.price,
    required this.buy,
    this.free = false,
    this.note,
    this.blockedBecause,
  });

  final String id;
  final String emoji;
  final String title;
  final String text;

  /// Was es kosten würde, z. B. "0,99 €".
  final String price;

  /// Gerade gratis (dann wird nichts bezahlt).
  final bool free;

  /// Ein Hinweis unter dem Preis, z. B. wann es wieder gratis ist.
  final String? note;

  /// Warum man es gerade nicht kaufen kann; null, wenn es geht.
  final String? blockedBecause;

  /// Führt den Kauf aus und sagt, was passiert ist.
  final Future<String> Function() buy;
}
