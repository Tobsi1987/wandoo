import 'package:flutter/material.dart';
import 'package:wandoo/features/friends/domain/friend_card.dart';
import 'package:wandoo/features/friends/presentation/scan_screen.dart';

/// Holt die Karte eines Freundes: mit der Kamera oder als eingefügter Text.
Future<FriendCard?> scanFriend(BuildContext context) => Navigator.of(
  context,
).push<FriendCard>(MaterialPageRoute(builder: (_) => const ScanScreen()));

Future<FriendCard?> pasteFriend(BuildContext context) async {
  final text = await _ask(
    context,
    title: 'Code einfügen',
    hint: 'wandoo:1:…',
    key: 'paste-code',
  );
  return text == null ? null : FriendCard.decode(text);
}

/// Wie dein Freund in deiner Liste heißen soll. Bleibt nur bei dir.
Future<String?> askFriendName(BuildContext context, {String? before}) async {
  final name = await _ask(
    context,
    title: 'Wie heißt dein Freund?',
    hint: 'Name, nur für dich',
    key: 'friend-name',
    initial: before,
  );
  final trimmed = name?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}

Future<String?> _ask(
  BuildContext context, {
  required String title,
  required String hint,
  required String key,
  String? initial,
}) => showDialog<String>(
  context: context,
  builder: (context) =>
      _AskDialog(title: title, hint: hint, fieldKey: key, initial: initial),
);

/// Ein Dialog mit einem Textfeld; er räumt sein Feld selbst auf.
class _AskDialog extends StatefulWidget {
  const _AskDialog({
    required this.title,
    required this.hint,
    required this.fieldKey,
    this.initial,
  });

  final String title;
  final String hint;
  final String fieldKey;
  final String? initial;

  @override
  State<_AskDialog> createState() => _AskDialogState();
}

class _AskDialogState extends State<_AskDialog> {
  late final _field = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: TextField(
      key: Key(widget.fieldKey),
      controller: _field,
      autofocus: true,
      maxLength: widget.fieldKey == 'friend-name' ? 20 : null,
      decoration: InputDecoration(hintText: widget.hint),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Abbrechen'),
      ),
      TextButton(
        key: Key('${widget.fieldKey}-ok'),
        onPressed: () => Navigator.pop(context, _field.text),
        child: const Text('OK'),
      ),
    ],
  );
}
