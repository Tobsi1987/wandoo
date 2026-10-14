import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/privacy/application/privacy_providers.dart';
import 'package:wandoo/features/privacy/presentation/privacy_intro.dart';

/// Zeigt die App erst, wenn der Hinweis zum Datenschutz bestätigt ist.
/// Bis dahin geht nichts ins Netz, weil kein Gang starten kann.
class PrivacyGate extends ConsumerWidget {
  const PrivacyGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choices = ref.watch(privacyChoicesProvider);
    if (choices == null) {
      return ColoredBox(color: Theme.of(context).colorScheme.surface);
    }
    return choices.informed ? child : const PrivacyIntro();
  }
}
