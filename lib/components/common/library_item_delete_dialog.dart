import 'package:flutter/material.dart';

enum LibraryItemDeleteMode { absOnly, absAndFileSystem }

Future<LibraryItemDeleteMode?> showLibraryItemDeleteDialog({
  required BuildContext context,
  required int deleteCount,
  int skippedCount = 0,
}) {
  return showDialog<LibraryItemDeleteMode>(
    context: context,
    builder: (dialogContext) {
      return LibraryItemDeleteDialog(deleteCount: deleteCount, skippedCount: skippedCount);
    },
  );
}

class LibraryItemDeleteDialog extends StatelessWidget {
  const LibraryItemDeleteDialog({super.key, required this.deleteCount, this.skippedCount = 0});

  final int deleteCount;
  final int skippedCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSingle = deleteCount == 1;

    final title = isSingle ? 'Delete audiobook?' : 'Delete audiobooks?';
    final warning = isSingle
        ? 'This action will remove the audiobook from Audiobookshelf and cannot be undone.'
        : 'This action will remove $deleteCount audiobooks from Audiobookshelf and cannot be undone.';

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(warning),
            const SizedBox(height: 8),
            Text(
              'Choose deletion mode:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (skippedCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '$skippedCount selected item(s) are not audiobooks and will be skipped.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ),
            const SizedBox(height: 10),
            LibraryItemDeleteOptionTile(
              icon: Icons.delete_outline_rounded,
              title: 'Delete from Audiobookshelf only',
              subtitle:
                  'Removes from ABS database, keeps media files on disk. It might come back after ABS rescans the library/file system.',
              onTap: () => Navigator.of(context).pop(LibraryItemDeleteMode.absOnly),
            ),
            const SizedBox(height: 8),
            LibraryItemDeleteOptionTile(
              icon: Icons.delete_forever_rounded,
              title: 'Delete from Audiobookshelf and file system',
              subtitle: 'Permanently removes ABS entry and media files.',
              destructive: true,
              onTap: () => Navigator.of(context).pop(LibraryItemDeleteMode.absAndFileSystem),
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel'))],
    );
  }
}

class LibraryItemDeleteOptionTile extends StatelessWidget {
  const LibraryItemDeleteOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = destructive ? colorScheme.error : colorScheme.primary;
    final onSurfaceColor = destructive ? colorScheme.onErrorContainer : colorScheme.onSurface;
    final backgroundColor = destructive
        ? colorScheme.errorContainer.withValues(alpha: 0.48)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55);

    return Material(
      borderRadius: BorderRadius.circular(12),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: accentColor),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: onSurfaceColor)),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: destructive
                            ? colorScheme.onErrorContainer.withValues(alpha: 0.9)
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}
