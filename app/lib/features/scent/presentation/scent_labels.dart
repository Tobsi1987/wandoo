import 'package:wandoo/features/scent/domain/scent_hint.dart';

/// Was die Spürnase zu einem Hinweis sagt, wie beim Heiß-und-kalt-Spiel.
String heatLabel(Heat heat, String name) => switch (heat) {
  Heat.found => '🎉 Hier! $name hat etwas gefunden',
  Heat.hot => '🔥 Ganz heiß!',
  Heat.warm => '☀️ Warm',
  Heat.cool => '🌥️ Kühl',
  Heat.cold => '❄️ Kalt',
};

/// Entfernung grob gerundet, damit sie nicht ständig springt.
String roughMeters(double meters) {
  final step = meters < 100 ? 10 : 50;
  return 'noch etwa ${(meters / step).round() * step} m';
}
