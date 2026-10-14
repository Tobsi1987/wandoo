import 'package:wandoo/features/sounds/domain/cue.dart';
import 'package:wandoo/features/sounds/domain/sound_player.dart';
import 'package:wandoo/features/sounds/domain/voice.dart';

/// Spielt nichts, merkt sich aber, was gespielt worden wäre (für Tests).
class SilentSoundPlayer implements SoundPlayer {
  final List<(Cue, Voice)> played = [];

  @override
  Future<void> play(Cue cue, Voice voice) async => played.add((cue, voice));
}
