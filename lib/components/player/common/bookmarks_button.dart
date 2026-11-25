import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/screens/player/bookmarks_sheet.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';

void showPlayerBookmarksSheet(BuildContext context) {
  final messenger = ScaffoldMessenger.of(context);

  if (audioHandler.isReaderNarration) {
    messenger.showSnackBar(SnackBar(content: Text(context.l10n.playerBookmarkInReader)));
    return;
  }

  final media = audioHandler.currentMediaItem;

  if (media == null) {
    messenger.showSnackBar(SnackBar(content: Text(context.l10n.playerNoMediaToBookmark)));
    return;
  }

  showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) => PlayerBookmarksSheet(itemId: media.itemId, itemTitle: media.title),
  );
}

class BookmarksButton extends StatelessWidget {
  const BookmarksButton({super.key, this.iconSize});

  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final isReaderNarration = audioHandler.isReaderNarration;
    return YaabsaActionIconButton(
      icon: Icons.bookmarks_rounded,
      iconSize: iconSize ?? 24,
      buttonSize: 48,
      compact: false,
      enabled: !isReaderNarration,
      tooltip: isReaderNarration ? context.l10n.playerBookmarkInReader : context.l10n.navBookmarks,
      onPressed: isReaderNarration ? null : () => showPlayerBookmarksSheet(context),
    );
  }
}
