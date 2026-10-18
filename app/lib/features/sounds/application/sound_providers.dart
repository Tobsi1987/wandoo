import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/sounds/domain/cue.dart';
import 'package:wandoo/features/sounds/domain/sound_player.dart';
import 'package:wandoo/features/sounds/domain/sound_settings_repository.dart';
import 'package:wandoo/features/sounds/domain/voice.dart';

/// Hauptschalter: vorerst alle Töne aus, bis neue Sounds da sind.
/// Code und Dateien bleiben; einschalten mit
/// `--dart-define=WANDOO_SOUNDS=true`.
const soundsEnabled = bool.fromEnvironment('WANDOO_SOUNDS');

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final soundPlayerProvider = Provider<SoundPlayer>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final soundSettingsRepositoryProvider = Provider<SoundSettingsRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

/// Ob die Laute aus sind.
final soundsMutedProvider = StreamProvider<bool>(
  (ref) => ref.watch(soundSettingsRepositoryProvider).watchMuted(),
);

final playSoundProvider = Provider<PlaySound>(
  (ref) => PlaySound(
    player: ref.watch(soundPlayerProvider),
    settings: ref.watch(soundSettingsRepositoryProvider),
  ),
);

/// Spielt einen Laut in der Stimme eines Wesens, außer die Laute sind aus.
class PlaySound {
  PlaySound({required this.player, required this.settings});

  final SoundPlayer player;
  final SoundSettingsRepository settings;

  Future<void> call(Cue cue, {String? speciesId}) async {
    if (await settings.muted()) return;
    await player.play(cue, cue.voiced ? voiceFor(speciesId) : Voice.mid);
  }
}
