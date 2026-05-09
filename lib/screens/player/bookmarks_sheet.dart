import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/provider/player/user_bookmarks_provider.dart';
import 'package:yaabsa/screens/player/components/bookmark_title_dialog.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';

class PlayerBookmarksSheet extends ConsumerStatefulWidget {
  const PlayerBookmarksSheet({super.key, required this.itemId, required this.itemTitle});

  final String itemId;
  final String itemTitle;

  @override
  ConsumerState<PlayerBookmarksSheet> createState() => _PlayerBookmarksSheetState();
}

class _PlayerBookmarksSheetState extends ConsumerState<PlayerBookmarksSheet> {
  bool _isCreating = false;
  final Set<int> _deletingTimes = <int>{};

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

  Future<String?> _promptBookmarkTitle() {
    return BookmarkTitleDialog.show(context);
  }

  Future<void> _startCreateBookmarkFlow() async {
    if (_isCreating) {
      return;
    }

    final position = audioHandler.position;
    final bookmarkTime = position.inSeconds;
    if (bookmarkTime <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Play a little further before creating a bookmark.')));
      return;
    }

    final inputTitle = await _promptBookmarkTitle();
    if (!mounted || inputTitle == null) {
      return;
    }

    final title = inputTitle.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter bookmark text.')));
      return;
    }

    await _createBookmarkAtCurrentPosition(title: title);
  }

  Future<void> _createBookmarkAtCurrentPosition({required String title}) async {
    final messenger = ScaffoldMessenger.of(context);

    final position = audioHandler.position;
    final bookmarkTime = position.inSeconds;
    if (bookmarkTime <= 0) {
      messenger.showSnackBar(const SnackBar(content: Text('Play a little further before creating a bookmark.')));
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final createdBookmark = await ref
          .read(userBookmarksProvider.notifier)
          .createBookmark(itemId: widget.itemId, time: bookmarkTime, title: title);

      if (!mounted) {
        return;
      }

      if (createdBookmark == null) {
        messenger.showSnackBar(const SnackBar(content: Text('Failed to create bookmark.')));
        return;
      }

      messenger.showSnackBar(SnackBar(content: Text('Bookmark added at ${position.toHhMmString()}')));
    } catch (_) {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(const SnackBar(content: Text('Could not create bookmark right now.')));
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  Future<void> _deleteBookmark(Bookmark bookmark) async {
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _deletingTimes.add(bookmark.time);
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
          _deletingTimes.remove(bookmark.time);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allBookmarks = ref.watch(userBookmarksProvider).value ?? const <Bookmark>[];
    final bookmarks = _bookmarksForCurrentItem(allBookmarks);

    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: SizedBox(
        height: maxHeight,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 16 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bookmarks', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                widget.itemTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              StreamBuilder<Duration>(
                stream: audioHandler.positionStream,
                initialData: audioHandler.position,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final canCreate = !_isCreating && position.inSeconds > 0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current position: ${position.inSeconds > 0 ? position.toHhMmString() : '--:--'}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: canCreate ? _startCreateBookmarkFlow : null,
                        icon: _isCreating
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.bookmark_add_outlined),
                        label: Text(_isCreating ? 'Adding bookmark...' : 'Create bookmark'),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: bookmarks.isEmpty
                    ? Center(
                        child: Text(
                          'No bookmarks yet',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      )
                    : ListView.separated(
                        itemCount: bookmarks.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final bookmark = bookmarks[index];
                          final deleting = _deletingTimes.contains(bookmark.time);
                          final title = bookmark.title.trim().isEmpty ? 'Untitled bookmark' : bookmark.title.trim();

                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.bookmark_rounded),
                            title: Text(title),
                            subtitle: Text(Duration(seconds: bookmark.time).toHhMmString()),
                            onTap: deleting
                                ? null
                                : () {
                                    audioHandler.seek(Duration(seconds: bookmark.time));
                                  },
                            trailing: deleting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _deleteBookmark(bookmark),
                                  ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
