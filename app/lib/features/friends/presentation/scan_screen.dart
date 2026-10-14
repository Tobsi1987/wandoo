import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wandoo/features/friends/domain/friend_card.dart';

/// Kamera auf den Code des Freundes halten; gibt seine Karte zurück.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  var _done = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Freund scannen')),
    body: MobileScanner(
      onDetect: (capture) {
        for (final code in capture.barcodes) {
          final card = FriendCard.decode(code.rawValue ?? '');
          if (card == null || _done) continue;
          _done = true;
          Navigator.pop(context, card);
          return;
        }
      },
    ),
  );
}
