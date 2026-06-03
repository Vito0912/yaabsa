import 'package:flutter/material.dart';
import 'package:yaabsa/screens/player/bookmarks_sheet.dart';
import 'package:yaabsa/util/globals.dart';

class BookmarksButton extends StatelessWidget {
  const BookmarksButton({super.key, this.iconSize});

  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        iconSize: iconSize,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        tooltip: 'Bookmarks',
        icon: const Icon(Icons.bookmarks_outlined),
        onPressed: () {
          final messenger = ScaffoldMessenger.of(context);
          final media = audioHandler.currentMediaItem;
          if (media == null) {
            messenger.showSnackBar(const SnackBar(content: Text('No active media to bookmark.')));
            return;
          }

          showModalBottomSheet<void>(
            context: context,
            useSafeArea: true,
            showDragHandle: true,
            isScrollControlled: true,
            builder: (BuildContext context) => PlayerBookmarksSheet(itemId: media.itemId, itemTitle: media.title),
          );
        },
      ),
    );
  }
}
