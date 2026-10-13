import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/share/application/share_caption.dart';
import 'package:wandoo/features/share/application/share_providers.dart';
import 'package:wandoo/features/share/presentation/capture_png.dart';
import 'package:wandoo/features/share/presentation/widgets/share_card.dart';

/// Vorschau des Teilen-Bilds mit Knopf zum Teilen.
class ShareScreen extends ConsumerStatefulWidget {
  const ShareScreen({super.key});

  static const path = '/teilen';

  @override
  ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _busy = false;

  Future<void> _share(Creature creature) async {
    setState(() => _busy = true);
    try {
      final png = await capturePng(_cardKey);
      await ref
          .read(imageSharerProvider)
          .sharePng(png, text: shareCaption(creature));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final creature = ref.watch(creatureProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Wesen teilen')),
      body: creature == null
          ? const Center(child: CircularProgressIndicator())
          : _Preview(
              cardKey: _cardKey,
              creature: creature,
              onShare: _busy ? null : () => _share(creature),
            ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    required this.cardKey,
    required this.creature,
    required this.onShare,
  });

  final GlobalKey cardKey;
  final Creature creature;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: Center(
          child: FittedBox(
            child: RepaintBoundary(
              key: cardKey,
              child: ShareCard(creature: creature),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(24),
        child: FilledButton.icon(
          onPressed: onShare,
          icon: const Icon(Icons.ios_share),
          label: const Text('Teilen'),
        ),
      ),
    ],
  );
}
