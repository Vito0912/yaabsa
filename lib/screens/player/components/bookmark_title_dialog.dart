import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/extensions.dart';

class BookmarkTitleDialog extends StatefulWidget {
  const BookmarkTitleDialog({super.key, required this.bookmarkTime, this.initialText = ''});

  final Duration bookmarkTime;
  final String initialText;

  bool get isEditing => initialText.trim().isNotEmpty;

  static Future<String?> show(BuildContext context, {required Duration bookmarkTime, String initialText = ''}) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) =>
          BookmarkTitleDialog(bookmarkTime: bookmarkTime, initialText: initialText),
    );
  }

  @override
  State<BookmarkTitleDialog> createState() => _BookmarkTitleDialogState();
}

class _BookmarkTitleDialogState extends State<BookmarkTitleDialog> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialText);
    _titleController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_handleTextChanged);
    _titleController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    setState(() {});
  }

  void _submit() {
    final text = _titleController.text.trim();
    if (text.isNotEmpty) {
      Navigator.of(context).pop(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _titleController.text.trim().isNotEmpty;

    return AlertDialog(
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  widget.isEditing ? Icons.edit_note_rounded : Icons.bookmark_add_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(widget.bookmarkTime.toPlaybackTimeString(), style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              autofocus: true,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Note',
                hintText: 'What do you want to remember?',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton.icon(
          onPressed: isValid ? _submit : null,
          icon: Icon(widget.isEditing ? Icons.check_rounded : Icons.add_rounded),
          label: Text(widget.isEditing ? 'Save' : 'Add bookmark'),
        ),
      ],
    );
  }
}
