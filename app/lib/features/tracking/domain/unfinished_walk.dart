import 'package:geo_engine/geo_engine.dart';

/// Was mit einem Gang passiert, der beim App-Start noch offen ist (die App
/// wurde mitten im Gang beendet).
enum UnfinishedWalkAction {
  /// Kurz her: weiter aufzeichnen, als wäre nichts gewesen.
  resume,

  /// Länger her: so abschließen, wie er ist, damit nichts verloren geht.
  finish,

  /// Zu wenig für einen Gang: verwerfen.
  discard,
}

/// Entscheidet anhand des letzten Punkts, ob ein offener Gang weiterläuft.
class UnfinishedWalkPolicy {
  const UnfinishedWalkPolicy({this.resumeWithin = const Duration(minutes: 30)});

  final Duration resumeWithin;

  UnfinishedWalkAction decide(Track track, DateTime now) {
    if (track.points.length < 2) return UnfinishedWalkAction.discard;
    final last = track.points.last.time;
    return now.difference(last) <= resumeWithin
        ? UnfinishedWalkAction.resume
        : UnfinishedWalkAction.finish;
  }
}
