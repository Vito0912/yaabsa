import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_overlay.dart';
import 'package:yaabsa/components/app/item/editor/open_library_item_editor_dialog.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/item/library_item_book_view.dart';
import 'package:yaabsa/screens/item/library_item_podcast_view.dart';

class LibraryItemView extends ConsumerStatefulWidget {
  const LibraryItemView(this.itemId, {super.key, this.initialEditorTab});

  final String itemId;
  final String? initialEditorTab;

  @override
  ConsumerState<LibraryItemView> createState() => _LibraryItemViewState();
}

class _LibraryItemViewState extends ConsumerState<LibraryItemView> {
  var _didOpenInitialEditor = false;

  @override
  void didUpdateWidget(covariant LibraryItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemId != widget.itemId || oldWidget.initialEditorTab != widget.initialEditorTab) {
      _didOpenInitialEditor = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemAsync = ref.watch(libraryItemProvider(widget.itemId));
    final canDownload = ref.watch(currentUserProvider).value?.permissions.download ?? false;
    return itemAsync.when(
      data: (item) {
        final isPodcast = item.mediaType == 'podcast' || item.media?.podcastMedia != null;
        _scheduleInitialEditor(item, isPodcast: isPodcast);
        return isPodcast
            ? LibraryItemPodcastView(item: item, canDownload: canDownload)
            : LibraryItemBookView(item: item, canDownload: canDownload);
      },
      error: (error, stackTrace) {
        final isNotFound = _isNotFoundError(error);
        return ConnectionIssueView.requestFailed(
          error: error,
          title: isNotFound ? 'Item not found' : 'Unable to load item',
          message: isNotFound
              ? 'This item may have been moved or deleted.'
              : 'Please try again. If the issue persists, check your server connection.',
          showDownloadsShortcut: !isNotFound,
          onRetry: () async {
            ref.invalidate(libraryItemProvider(widget.itemId));
            await ref.read(libraryItemProvider(widget.itemId).future);
          },
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _scheduleInitialEditor(LibraryItem item, {required bool isPodcast}) {
    if (_didOpenInitialEditor || isPodcast || widget.initialEditorTab != 'encoder') {
      return;
    }

    _didOpenInitialEditor = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      unawaited(
        openSingleLibraryItemEditorDialog(
          context: context,
          item: item,
          filterData: null,
          initialTab: LibraryItemEditorTab.encoder,
        ),
      );
    });
  }
}

bool _isNotFoundError(Object error) {
  final message = error.toString().toLowerCase();
  return message.contains('404') || message.contains('not found');
}
