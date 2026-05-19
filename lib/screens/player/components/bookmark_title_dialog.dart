import 'package:flutter/material.dart';

import 'package:yaabsa/generated/l10n.dart';

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
      title: Text(S.current.screensPlayerComponentsBookmarkTitleDialogCreateBookmark),
      content: TextField(
        controller: _titleController,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        minLines: 3,
        maxLines: 6,
        decoration: InputDecoration(
          labelText: S.current.screensPlayerComponentsBookmarkTitleDialogBookmarkText,
          hintText: S.current.screensPlayerComponentsBookmarkTitleDialogEnterBookmark,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.current.screensPlayerComponentsBookmarkTitleDialogCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_titleController.text),
          child: Text(S.current.screensPlayerComponentsBookmarkTitleDialogCreate),
        ),
      ],
    );
  }
}
