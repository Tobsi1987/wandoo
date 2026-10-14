import 'package:flutter/material.dart';

/// Oben: gefangene Sterne und die verbleibende Zeit.
class StarCatchHud extends StatelessWidget {
  const StarCatchHud({
    required this.caught,
    required this.secondsLeft,
    super.key,
  });

  final int caught;
  final int secondsLeft;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Semantics(
            label: '$caught gefangen',
            excludeSemantics: true,
            child: Text('⭐ $caught', style: style),
          ),
          const Spacer(),
          Semantics(
            label: 'noch $secondsLeft Sekunden',
            excludeSemantics: true,
            child: Text('⏱️ $secondsLeft', style: style),
          ),
        ],
      ),
    );
  }
}

/// Zum Schluss: wie viele gefangen wurden und was es dafür gibt.
class StarCatchResult extends StatelessWidget {
  const StarCatchResult({
    required this.name,
    required this.caught,
    required this.shards,
    required this.onDone,
    super.key,
  });

  final String name;
  final int caught;

  /// null, solange die Belohnung noch vergeben wird.
  final int? shards;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final shards = this.shards;
    final reward = shards == null
        ? ''
        : shards == 0
        ? 'Nächstes Mal klappt es bestimmt!'
        : '$name bekommt ⭐ $shards '
              'Sternsplitter '
              'für die Schatzkiste.';
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                caught == 1
                    ? '🌠 1 Sternschnuppe gefangen!'
                    : '🌠 $caught Sternschnuppen gefangen!',
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(reward, style: text.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: shards == null ? null : onDone,
                child: const Text('Fertig'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Am Anfang kurz: so wird gespielt.
class StarCatchIntro extends StatelessWidget {
  const StarCatchIntro({required this.visible, super.key});

  final bool visible;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: const Center(
        child: Text(
          'Fang die Sternschnuppen!\nWisch nach links und rechts.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            shadows: [Shadow(blurRadius: 8)],
          ),
        ),
      ),
    ),
  );
}
