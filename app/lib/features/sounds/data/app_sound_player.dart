import 'package:wandoo/features/sounds/data/audioplayers_sound_player.dart';
import 'package:wandoo/features/sounds/data/silent_sound_player.dart';
import 'package:wandoo/features/sounds/domain/sound_player.dart';
import 'package:wandoo/features/sounds/domain/sound_switch.dart';

/// Der Player für App und Demo: echte Töne nur, wenn [soundsEnabled] an ist.
SoundPlayer appSoundPlayer() =>
    soundsEnabled ? AudioplayersSoundPlayer() : const OffSoundPlayer();
