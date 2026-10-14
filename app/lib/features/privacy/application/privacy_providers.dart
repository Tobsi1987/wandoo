import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/privacy/domain/data_wiper.dart';
import 'package:wandoo/features/privacy/domain/privacy_choices.dart';
import 'package:wandoo/features/privacy/domain/privacy_repository.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final privacyRepositoryProvider = Provider<PrivacyRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final dataWiperProvider = Provider<DataWiper>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final _choicesProvider = StreamProvider<PrivacyChoices>(
  (ref) => ref.watch(privacyRepositoryProvider).watch(),
);

/// Die Einstellungen, oder null, solange sie noch laden.
final privacyChoicesProvider = Provider<PrivacyChoices?>(
  (ref) => ref.watch(_choicesProvider).value,
);

/// Darf das Wetter abgefragt werden?
final weatherAllowedProvider = Provider<bool>(
  (ref) => ref.watch(privacyChoicesProvider)?.weather ?? false,
);

/// Darf das Kartenbild geladen werden?
final baseMapAllowedProvider = Provider<bool>(
  (ref) => ref.watch(privacyChoicesProvider)?.baseMap ?? false,
);

/// Ändert eine Einstellung.
final updatePrivacyProvider =
    Provider<Future<void> Function(PrivacyChoices Function(PrivacyChoices))>(
      (ref) => (change) async {
        final repo = ref.read(privacyRepositoryProvider);
        final now = ref.read(privacyChoicesProvider) ?? const PrivacyChoices();
        await repo.save(change(now));
      },
    );
