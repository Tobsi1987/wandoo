/// Öffentliche Schnittstelle von `privacy`.
///
/// Nur exportieren, was andere Module wirklich brauchen.
library;

export 'application/privacy_providers.dart'
    show
        baseMapAllowedProvider,
        dataWiperProvider,
        privacyChoicesProvider,
        privacyRepositoryProvider,
        weatherAllowedProvider;
export 'domain/data_wiper.dart';
export 'domain/privacy_choices.dart';
export 'domain/privacy_repository.dart';
export 'presentation/privacy_gate.dart';
export 'presentation/privacy_screen.dart';
