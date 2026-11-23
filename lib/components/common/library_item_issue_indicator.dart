import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/library_item.dart';

class LibraryItemIssueIndicator extends StatelessWidget {
  const LibraryItemIssueIndicator({super.key, required this.item, this.expanded = false});

  final LibraryItem item;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    if (!item.hasIssue) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).colorScheme;
    final message = item.isMissing == true
        ? 'The server cannot find this item’s files. Restore them and rescan the library'
        : 'This item has invalid or incomplete media files on the server';

    return Tooltip(
      message: message,
      child: Semantics(
        label: '${item.issueLabel}. $message',
        child: Container(
          padding: EdgeInsets.all(expanded ? 12 : 6),
          decoration: BoxDecoration(
            color: colors.errorContainer,
            borderRadius: BorderRadius.circular(expanded ? 16 : 100),
          ),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, color: colors.onErrorContainer, size: 20),
              if (expanded) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${item.issueLabel}: $message Downloaded files remain available.',
                    style: TextStyle(color: colors.onErrorContainer),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
