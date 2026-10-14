import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/levels/application/level_providers.dart';
import 'package:wandoo/features/levels/domain/progress.dart';

/// Zeigt Level-Aufstiege, die nicht nach einem Gang kamen (zum Beispiel
/// beim Streicheln), für ein paar Sekunden oder bis man drauftippt.
class LevelUpBanner extends ConsumerStatefulWidget {
  const LevelUpBanner({super.key});

  /// So lange bleibt die Nachricht stehen.
  static const shown = Duration(seconds: 3);

  @override
  ConsumerState<LevelUpBanner> createState() => _LevelUpBannerState();
}

class _LevelUpBannerState extends ConsumerState<LevelUpBanner> {
  List<String> _lines = const [];
  Timer? _hide;

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      progressProvider,
      (_, progress) => _take(progress),
      fireImmediately: true,
    );
  }

  /// Nimmt neue Nachrichten an sich und leert den Speicher sofort, damit
  /// nichts hängen bleibt.
  void _take(Progress? progress) {
    if (progress == null || progress.news.isEmpty) return;
    final lines = progress.news;
    unawaited(
      ref
          .read(progressRepositoryProvider)
          .save(progress.copyWith(news: const [])),
    );
    // Nicht mitten im Aufbau zeigen; der Listener kann dort feuern.
    scheduleMicrotask(() {
      if (!mounted) return;
      setState(() => _lines = [..._lines, ...lines]);
      _hide?.cancel();
      _hide = Timer(LevelUpBanner.shown, _close);
    });
  }

  void _close() {
    _hide?.cancel();
    if (mounted) setState(() => _lines = const []);
  }

  @override
  void dispose() {
    _hide?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _lines.isEmpty
          ? const SizedBox.shrink()
          : Semantics(
              key: ValueKey(_lines),
              container: true,
              button: true,
              child: GestureDetector(
                onTap: _close,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final line in _lines)
                          Text(
                            line,
                            style: text.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
