import 'dart:developer' as developer;

import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/flows/process_walk/process_walk.dart';
import 'package:wandoo/flows/process_walk/walk_result.dart';

/// Verarbeitet alle fertigen, aber noch offenen Gänge der Reihe nach.
///
/// Scheitert ein Gang (zum Beispiel offline, keine Kartendaten), bleibt er
/// offen und wird beim nächsten Anstoß erneut versucht.
class PendingWalkProcessor {
  PendingWalkProcessor({required this.walks, required this.process});

  final RecordedWalkRepository walks;
  final ProcessWalk process;
  bool _running = false;

  /// Liefert die Ergebnisse der erfolgreich verarbeiteten Gänge.
  Future<List<WalkResult>> processAll() async {
    if (_running) return const [];
    _running = true;
    final results = <WalkResult>[];
    try {
      for (final track in await walks.pending()) {
        results.add(await process(track));
        await walks.markProcessed(track.id);
      }
    } on Object catch (error, stack) {
      developer.log(
        'Gang konnte nicht verarbeitet werden, später erneut.',
        name: 'wandoo.process_walk',
        error: error,
        stackTrace: stack,
      );
    } finally {
      _running = false;
    }
    return results;
  }
}
