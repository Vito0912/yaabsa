import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/provider/player/user_bookmarks_provider.dart';
import 'package:yaabsa/screens/player/components/bookmark_title_dialog.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';

class BookmarkAddButton extends ConsumerStatefulWidget {
  const BookmarkAddButton({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<BookmarkAddButton> createState() => _BookmarkAddButtonState();
}

class _BookmarkAddButtonState extends ConsumerState<BookmarkAddButton> {
  bool _isCreating = false;

  Future<void> _addBookmark() async {
    if (_isCreating) {
      return;
    }

    final bookmarkTime = audioHandler.position.inSeconds;
    if (bookmarkTime <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Play a little further before creating a bookmark.')));
      return;
    }

    final title = await BookmarkTitleDialog.show(context, bookmarkTime: Duration(seconds: bookmarkTime));
    if (!mounted || title == null) {
      return;
    }

    setState(() {
      _isCreating = true;
    });
    final messenger = ScaffoldMessenger.of(context);

    try {
      final bookmark = await ref
          .read(userBookmarksProvider.notifier)
          .createBookmark(itemId: widget.itemId, time: bookmarkTime, title: title);
      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            bookmark == null
                ? 'Failed to create bookmark.'
                : 'Bookmark added at ${Duration(seconds: bookmarkTime).toHhMmString()}',
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(const SnackBar(content: Text('Could not create bookmark right now.')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: audioHandler.positionStream,
      initialData: audioHandler.position,
      builder: (context, snapshot) {
        final canCreate = !_isCreating && (snapshot.data ?? Duration.zero).inSeconds > 0;
        return FilledButton.icon(
          onPressed: canCreate ? _addBookmark : null,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            visualDensity: VisualDensity.compact,
          ),
          icon: _isCreating
              ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.add_rounded),
          label: Text(_isCreating ? 'Adding' : 'Add bookmark'),
        );
      },
    );
  }
}
