import 'dart:typed_data';

/// Gibt ein fertiges Bild an das Teilen-Menü des Systems weiter.
abstract interface class ImageSharer {
  Future<void> sharePng(Uint8List png, {required String text});
}
