import 'dart:async';

import 'package:wandoo/features/sounds/domain/sound_settings_repository.dart';

/// Hält "Laute aus" nur im Speicher, für Demo und Tests.
class InMemorySoundSettingsRepository implements SoundSettingsRepository {
  bool _muted = false;
  final _changes = StreamController<bool>.broadcast();

  @override
  Future<bool> muted() async => _muted;

  @override
  Future<void> setMuted({required bool muted}) async =>
      _changes.add(_muted = muted);

  @override
  Stream<bool> watchMuted() async* {
    yield _muted;
    yield* _changes.stream;
  }
}
