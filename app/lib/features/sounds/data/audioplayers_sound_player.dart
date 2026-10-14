import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';
import 'package:wandoo/features/sounds/domain/cue.dart';
import 'package:wandoo/features/sounds/domain/sound_player.dart';
import 'package:wandoo/features/sounds/domain/voice.dart';

/// Spielt die Laute mit `audioplayers`, ein Player je Laut.
class AudioplayersSoundPlayer implements SoundPlayer {
  final Map<Cue, AudioPlayer> _players = {};

  @override
  Future<void> play(Cue cue, Voice voice) async {
    try {
      final player = _players[cue] ??= AudioPlayer();
      await player.stop();
      await player.play(AssetSource(cue.asset(voice)));
    } on Object catch (error) {
      // Ein Laut, der nicht klappt, darf nichts anderes stören.
      developer.log('Laut $cue fehlt', name: 'wandoo.sounds', error: error);
    }
  }
}
