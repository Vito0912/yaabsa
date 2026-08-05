import 'package:flutter/material.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/screens/player/bookmarks_sheet.dart';
import 'package:yaabsa/screens/player/chapter.dart';
import 'package:yaabsa/screens/player/components/bookmark_add_button.dart';
import 'package:yaabsa/screens/player/queue.dart';

enum DesktopPlayerPanelType { bookmarks, chapters, queue }

extension on DesktopPlayerPanelType {
  bool get opensFromLeft => this == DesktopPlayerPanelType.bookmarks;

  String get label => switch (this) {
    DesktopPlayerPanelType.bookmarks => 'Bookmarks',
    DesktopPlayerPanelType.chapters => 'Chapters',
    DesktopPlayerPanelType.queue => 'Queue',
  };

  IconData get icon => switch (this) {
    DesktopPlayerPanelType.bookmarks => Icons.bookmarks_rounded,
    DesktopPlayerPanelType.chapters => Icons.menu_book_rounded,
    DesktopPlayerPanelType.queue => Icons.queue_music_rounded,
  };
}

Future<void> showDesktopPlayerSidePanel(
  BuildContext context, {
  required DesktopPlayerPanelType type,
  required InternalMedia media,
}) {
  final fromLeft = type.opensFromLeft;
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close ${type.label}',
    barrierColor: Colors.black.withValues(alpha: 0.28),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, animation, secondaryAnimation) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final panelWidth = (screenWidth * 0.34).clamp(360.0, 480.0);
      final outerRadius = BorderRadius.only(
        topRight: Radius.circular(fromLeft ? 30 : 0),
        bottomRight: Radius.circular(fromLeft ? 30 : 0),
        topLeft: Radius.circular(fromLeft ? 0 : 30),
        bottomLeft: Radius.circular(fromLeft ? 0 : 30),
      );

      return SafeArea(
        child: Align(
          alignment: fromLeft ? Alignment.centerLeft : Alignment.centerRight,
          child: SizedBox(
            width: panelWidth,
            height: double.infinity,
            child: Material(
              elevation: 16,
              color: Theme.of(context).colorScheme.surfaceContainer,
              surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
              shape: RoundedRectangleBorder(borderRadius: outerRadius),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
                    child: Row(
                      children: <Widget>[
                        Icon(type.icon),
                        const SizedBox(width: 12),
                        Expanded(child: Text(type.label, style: Theme.of(context).textTheme.titleLarge)),
                        if (type == DesktopPlayerPanelType.bookmarks) BookmarkAddButton(itemId: media.itemId),
                        IconButton(
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
                  Expanded(
                    child: _DesktopPanelContent(type: type, media: media),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
      return SlideTransition(
        position: Tween<Offset>(begin: Offset(fromLeft ? -1 : 1, 0), end: Offset.zero).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}

class _DesktopPanelContent extends StatelessWidget {
  const _DesktopPanelContent({required this.type, required this.media});

  final DesktopPlayerPanelType type;
  final InternalMedia media;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      DesktopPlayerPanelType.bookmarks => PlayerBookmarksSheet(
        itemId: media.itemId,
        itemTitle: media.title,
        embedded: true,
      ),
      DesktopPlayerPanelType.chapters => const Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: ChapterView(),
      ),
      DesktopPlayerPanelType.queue => const Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: PlayerQueueView(showEmptyIcon: false),
      ),
    };
  }
}
