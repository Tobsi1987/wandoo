import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/privacy/application/privacy_providers.dart';
import 'package:wandoo/features/privacy/presentation/widgets/privacy_switches.dart';
import 'package:wandoo/features/privacy/presentation/widgets/privacy_text.dart';

/// Kommt einmal beim ersten Start: was Wandoo mit Daten macht, zwei
/// Schalter und ein Knopf zum Loslegen.
class PrivacyIntro extends ConsumerWidget {
  const PrivacyIntro({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Text('Willkommen bei Wandoo', style: text.headlineSmall),
            const SizedBox(height: 12),
            Text(
              'Was dein Wesen erlebt, bleibt auf diesem Handy. Es gibt kein '
              'Konto, keine Werbung und keine Auswertung. Ins Internet gehen '
              'nur die Straßen der Gegend, und wenn du willst, Wetter und '
              'Kartenbild.',
              style: text.bodyLarge,
            ),
            const SizedBox(height: 12),
            const PrivacySwitches(),
            const ExpansionTile(
              key: Key('privacy-details'),
              tilePadding: EdgeInsets.zero,
              title: Text('Alles genau lesen'),
              childrenPadding: EdgeInsets.only(bottom: 8),
              children: [PrivacyText()],
            ),
            const SizedBox(height: 12),
            FilledButton(
              key: const Key('privacy-ok'),
              onPressed: () => ref.read(updatePrivacyProvider)(
                (c) => c.copyWith(informed: true),
              ),
              child: const Text('Verstanden, los geht’s'),
            ),
            const SizedBox(height: 8),
            Text(
              'Du kannst das jederzeit im Sammelalbum unter Datenschutz '
              'ändern.',
              style: text.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
