import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/discovery_map/application/discovery_map_providers.dart';
import 'package:wandoo/features/discovery_map/presentation/widgets/discovery_map_view.dart';

/// Entdeckungskarte: was vom eigenen Ort schon bekannt ist.
class DiscoveryMapScreen extends ConsumerWidget {
  const DiscoveryMapScreen({super.key});

  static const path = '/karte';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(discoveryOverviewProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Entdeckungskarte')),
      body: overview.when(
        data: (o) => o == null
            ? const _Message('Ohne Standort kann die Karte nichts zeigen.')
            : DiscoveryMapView(overview: o),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            const _Message('Kartendaten konnten nicht geladen werden.'),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}
