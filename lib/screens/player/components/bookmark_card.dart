import 'package:flutter/material.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/util/extensions.dart';

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    super.key,
    required this.bookmark,
    required this.isBusy,
    required this.onSeek,
    required this.onEdit,
    required this.onDelete,
    required this.onSelect,
    required this.onLongPress,
    this.selectionMode = false,
    this.isSelected = false,
  });

  final Bookmark bookmark;
  final bool isBusy;
  final VoidCallback onSeek;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSelect;
  final VoidCallback onLongPress;
  final bool selectionMode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final note = bookmark.title.trim();

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: isSelected ? colorScheme.secondaryContainer : colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? colorScheme.secondary.withValues(alpha: 0.55)
              : colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isBusy
            ? null
            : selectionMode
            ? onSelect
            : onSeek,
        onLongPress: isBusy || selectionMode ? null : onLongPress,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.play_arrow_rounded, size: 17, color: colorScheme.onSecondaryContainer),
                    const SizedBox(width: 3),
                    Text(
                      Duration(seconds: bookmark.time).toHhMmString(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colorScheme.onSecondaryContainer),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 4),
                  child: Text(
                    note.isEmpty ? 'Untitled bookmark' : note,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: note.isEmpty ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                      fontStyle: note.isEmpty ? FontStyle.italic : FontStyle.normal,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
              if (selectionMode)
                Checkbox(value: isSelected, onChanged: isBusy ? null : (_) => onSelect())
              else if (isBusy)
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                )
              else
                PopupMenuButton<_BookmarkAction>(
                  tooltip: 'Bookmark actions',
                  onSelected: (action) {
                    switch (action) {
                      case _BookmarkAction.edit:
                        onEdit();
                      case _BookmarkAction.select:
                        onLongPress();
                      case _BookmarkAction.delete:
                        onDelete();
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry<_BookmarkAction>>[
                    const PopupMenuItem<_BookmarkAction>(
                      value: _BookmarkAction.edit,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Edit'),
                      ),
                    ),
                    const PopupMenuItem<_BookmarkAction>(
                      value: _BookmarkAction.select,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.check_circle_outline_rounded),
                        title: Text('Select'),
                      ),
                    ),
                    PopupMenuItem<_BookmarkAction>(
                      value: _BookmarkAction.delete,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.delete_outline_rounded, color: colorScheme.error),
                        title: Text('Delete', style: TextStyle(color: colorScheme.error)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _BookmarkAction { edit, select, delete }
