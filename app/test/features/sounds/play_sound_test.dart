import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/sounds/data/drift_sound_settings_repository.dart';
import 'package:wandoo/features/sounds/data/in_memory_sound_settings_repository.dart';
import 'package:wandoo/features/sounds/data/silent_sound_player.dart';
import 'package:wandoo/features/sounds/sounds.dart';

import '../../support/test_database.dart';

void main() {
  test('Stimme je Art, Glöckchen immer gleich, still wenn aus', () async {
    final player = SilentSoundPlayer();
    final settings = InMemorySoundSettingsRepository();
    final play = PlaySound(player: player, settings: settings);
    await play(Cue.happy, speciesId: 'wellenwal');
    await play(Cue.found, speciesId: 'wellenwal');
    await play(Cue.purr);
    expect(player.played, [
      (Cue.happy, Voice.low),
      (Cue.found, Voice.mid),
      (Cue.purr, Voice.mid),
    ]);
    await settings.setMuted(muted: true);
    await play(Cue.cheer, speciesId: 'funkel');
    expect(player.played, hasLength(3));
  });

  test('Datenbank merkt sich "Töne aus"', () async {
    final repo = DriftSoundSettingsRepository(testDatabase());
    expect(await repo.muted(), isFalse);
    await repo.setMuted(muted: true);
    expect(await repo.muted(), isTrue);
    await expectLater(repo.watchMuted(), emits(true));
  });

  test('jeder Laut hat eine Datei', () {
    for (final cue in Cue.values) {
      for (final voice in Voice.values) {
        final file = File('assets/${cue.asset(voice)}');
        expect(file.existsSync(), isTrue, reason: file.path);
      }
    }
  });
}
