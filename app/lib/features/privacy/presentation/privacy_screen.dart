import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/privacy/application/privacy_providers.dart';
import 'package:wandoo/features/privacy/presentation/widgets/privacy_switches.dart';
import 'package:wandoo/features/privacy/presentation/widgets/privacy_text.dart';

/// Datenschutz: die Schalter, die Erklärung und alles löschen.
class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({super.key});

  static const path = '/datenschutz';

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Datenschutz')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        const PrivacySwitches(),
        const SizedBox(height: 16),
        const PrivacyText(),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          key: const Key('privacy-wipe'),
          onPressed: () => unawaited(_wipe(context, ref)),
          icon: const Icon(Icons.delete_forever_rounded),
          label: const Text('Alle Daten löschen'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    ),
  );

  static Future<void> _wipe(BuildContext context, WidgetRef ref) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alles löschen?'),
        content: const Text(
          'Dein Wesen, alle Gänge, Straßen, Schätze und das Tagebuch sind '
          'dann für immer weg.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            key: const Key('privacy-wipe-yes'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (sure != true || !context.mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    await ref.read(dataWiperProvider).wipeAll();
  }
}
