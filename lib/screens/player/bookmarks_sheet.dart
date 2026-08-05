import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/provider/player/user_bookmarks_provider.dart';
import 'package:yaabsa/screens/player/components/bookmark_add_button.dart';
import 'package:yaabsa/screens/player/components/bookmark_card.dart';
import 'package:yaabsa/screens/player/components/bookmark_title_dialog.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';

class PlayerBookmarksSheet extends ConsumerStatefulWidget {
  const PlayerBookmarksSheet({super.key, required this.itemId, required this.itemTitle, this.embedded = false});

  final String itemId;
  final String itemTitle;
  final bool embedded;

  @override
  ConsumerState<PlayerBookmarksSheet> createState() => _PlayerBookmarksSheetState();
}

class _PlayerBookmarksSheetState extends ConsumerState<PlayerBookmarksSheet> {
  bool _isBulkDeleting = false;
  final Set<int> _busyTimes = <int>{};
  final Set<int> _selectedTimes = <int>{};

  @override
  void initState() {
    super.initState();
    unawaited(ref.read(userBookmarksProvider.notifier).refresh());
  }

  List<Bookmark> _bookmarksForCurrentItem(List<Bookmark> bookmarks) {
    final filtered = bookmarks
        .where((bookmark) => bookmark.libraryItemId == widget.itemId && bookmark.time > 0)
        .toList(growable: false);
    filtered.sort((left, right) => left.time.compareTo(right.time));
    return filtered;
  }

  Future<void> _editBookmark(Bookmark bookmark) async {
    final title = await BookmarkTitleDialog.show(
      context,
      bookmarkTime: Duration(seconds: bookmark.time),
      initialText: bookmark.title,
    );
    if (!mounted || title == null || title.trim() == bookmark.title.trim()) {
      return;
    }

    await _saveEditedBookmark(bookmark: bookmark, title: title);
  }

  Future<void> _saveEditedBookmark({required Bookmark bookmark, required String title}) async {
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _busyTimes.add(bookmark.time);
    });

    try {
      final savedBookmark = await ref
          .read(userBookmarksProvider.notifier)
          .updateBookmark(bookmark: bookmark, title: title);

      if (!mounted) {
        return;
      }

      if (savedBookmark == null) {
        messenger.showSnackBar(const SnackBar(content: Text('Failed to update bookmark.')));
        return;
      }

      messenger.showSnackBar(const SnackBar(content: Text('Bookmark updated.')));
    } catch (_) {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(const SnackBar(content: Text('Could not update bookmark right now.')));
    } finally {
      if (mounted) {
        setState(() {
          _busyTimes.remove(bookmark.time);
        });
      }
    }
  }

  Future<void> _deleteBookmark(Bookmark bookmark) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.delete_outline_rounded),
        title: const Text('Delete bookmark?'),
        content: Text(
          'Remove the bookmark at ${Duration(seconds: bookmark.time).toHhMmString()}? This can’t be undone.',
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(dialogContext).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _busyTimes.add(bookmark.time);
    });

    try {
      final deleted = await ref
          .read(userBookmarksProvider.notifier)
          .deleteBookmark(itemId: bookmark.libraryItemId, time: bookmark.time);

      if (!mounted) {
        return;
      }

      if (!deleted) {
        messenger.showSnackBar(const SnackBar(content: Text('Failed to delete bookmark.')));
        return;
      }

      messenger.showSnackBar(const SnackBar(content: Text('Bookmark deleted.')));
    } catch (_) {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(const SnackBar(content: Text('Could not delete bookmark right now.')));
    } finally {
      if (mounted) {
        setState(() {
          _busyTimes.remove(bookmark.time);
        });
      }
    }
  }

  void _startSelection(int time) {
    setState(() {
      _selectedTimes.add(time);
    });
  }

  void _toggleSelection(int time) {
    setState(() {
      if (!_selectedTimes.remove(time)) {
        _selectedTimes.add(time);
      }
    });
  }

  void _clearSelection() {
    setState(_selectedTimes.clear);
  }

  Future<void> _deleteSelectedBookmarks(List<Bookmark> bookmarks) async {
    final selectedBookmarks = bookmarks
        .where((bookmark) => _selectedTimes.contains(bookmark.time))
        .toList(growable: false);
    if (selectedBookmarks.isEmpty || _isBulkDeleting) {
      return;
    }

    final count = selectedBookmarks.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.delete_outline_rounded),
        title: Text('Delete $count ${count == 1 ? 'bookmark' : 'bookmarks'}?'),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(dialogContext).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _isBulkDeleting = true;
      _busyTimes.addAll(_selectedTimes);
    });

    var deletedCount = 0;
    try {
      for (final bookmark in selectedBookmarks) {
        final deleted = await ref
            .read(userBookmarksProvider.notifier)
            .deleteBookmark(itemId: bookmark.libraryItemId, time: bookmark.time);
        if (deleted) {
          deletedCount++;
        }
      }

      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text('$deletedCount ${deletedCount == 1 ? 'bookmark' : 'bookmarks'} deleted.')),
      );
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(const SnackBar(content: Text('Could not delete all selected bookmarks.')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBulkDeleting = false;
          _busyTimes.clear();
          _selectedTimes.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarksState = ref.watch(userBookmarksProvider);
    final allBookmarks = bookmarksState.value ?? const <Bookmark>[];
    final bookmarks = _bookmarksForCurrentItem(allBookmarks);
    final colorScheme = Theme.of(context).colorScheme;
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final horizontalPadding = context.isMobile ? 16.0 : 20.0;
    final selectionMode = _selectedTimes.isNotEmpty;

    final content = Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 4, horizontalPadding, 16 + bottomInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.embedded) ...<Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.bookmarks_rounded, color: colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(child: Text('Bookmarks', style: Theme.of(context).textTheme.headlineSmall)),
                BookmarkAddButton(itemId: widget.itemId),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Text(
            widget.itemTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          if (selectionMode)
            Row(
              children: <Widget>[
                IconButton(onPressed: _isBulkDeleting ? null : _clearSelection, icon: const Icon(Icons.close_rounded)),
                Expanded(child: Text('${_selectedTimes.length} selected')),
                FilledButton.icon(
                  onPressed: _isBulkDeleting ? null : () => _deleteSelectedBookmarks(bookmarks),
                  style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
                  icon: _isBulkDeleting
                      ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.delete_outline_rounded),
                  label: const Text('Delete'),
                ),
              ],
            ),
          if (selectionMode) const SizedBox(height: 16),
          Expanded(
            child: bookmarksState.isLoading && bookmarks.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : bookmarks.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.bookmark_add_outlined, size: 48, color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 12),
                          Text('No bookmarks yet', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            'Save a note at the current playback position to find it again later.',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: bookmarks.length,
                    padding: const EdgeInsets.only(bottom: 4),
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final bookmark = bookmarks[index];
                      return BookmarkCard(
                        bookmark: bookmark,
                        isBusy: _busyTimes.contains(bookmark.time),
                        onSeek: () => audioHandler.seekAbsolute(Duration(seconds: bookmark.time)),
                        onEdit: () => _editBookmark(bookmark),
                        onDelete: () => _deleteBookmark(bookmark),
                        selectionMode: selectionMode,
                        isSelected: _selectedTimes.contains(bookmark.time),
                        onSelect: () => _toggleSelection(bookmark.time),
                        onLongPress: () => _startSelection(bookmark.time),
                      );
                    },
                  ),
          ),
        ],
      ),
    );

    if (widget.embedded) {
      return content;
    }

    return SafeArea(
      child: SizedBox(height: maxHeight, child: content),
    );
  }
}
