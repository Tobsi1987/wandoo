import 'package:wandoo/features/sounds/domain/cue.dart';
import 'package:wandoo/features/sounds/domain/voice.dart';

/// Spielt einen Laut in einer Stimmlage ab.
abstract interface class SoundPlayer {
  Future<void> play(Cue cue, Voice voice);
}
