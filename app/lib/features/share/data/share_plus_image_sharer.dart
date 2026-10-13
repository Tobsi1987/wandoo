import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';
import 'package:wandoo/features/share/domain/image_sharer.dart';

/// Teilt über das native Teilen-Menü (Android und iOS).
class SharePlusImageSharer implements ImageSharer {
  const SharePlusImageSharer();

  @override
  Future<void> sharePng(Uint8List png, {required String text}) async {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        files: [XFile.fromData(png, mimeType: 'image/png')],
        fileNameOverrides: const ['wandoo.png'],
      ),
    );
  }
}
