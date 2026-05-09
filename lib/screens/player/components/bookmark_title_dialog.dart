import 'package:flutter/material.dart';

class BookmarkTitleDialog extends StatefulWidget {
  const BookmarkTitleDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(context: context, builder: (BuildContext dialogContext) => const BookmarkTitleDialog());
  }

  @override
  State<BookmarkTitleDialog> createState() => _BookmarkTitleDialogState();
}

class _BookmarkTitleDialogState extends State<BookmarkTitleDialog> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create bookmark'),
      content: TextField(
        controller: _titleController,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        minLines: 3,
        maxLines: 6,
        decoration: const InputDecoration(labelText: 'Bookmark text', hintText: 'Enter bookmark'),
      ),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.of(context).pop(_titleController.text), child: const Text('Create')),
      ],
    );
  }
}
