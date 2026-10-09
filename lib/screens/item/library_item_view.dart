import 'dart:async';

import 'package:yaabsa/components/common/screen_refresh_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_overlay.dart';
import 'package:yaabsa/components/app/item/editor/open_library_item_editor_dialog.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_item_sync.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/screens/item/library_item_book_view.dart';
import 'package:yaabsa/screens/item/library_item_podcast_view.dart';

class LibraryItemView extends ConsumerStatefulWidget {
  const LibraryItemView(this.itemId, {super.key, this.initialEditorTab, this.initialEpisodeId});

  final String itemId;
  final String? initialEditorTab;
  final String? initialEpisodeId;

  @override
  ConsumerState<LibraryItemView> createState() => _LibraryItemViewState();
}

class _LibraryItemViewState extends ConsumerState<LibraryItemView> {
  var _didOpenInitialEditor = false;

  Future<void> _refreshItem() async {
    final api = ref.read(absApiProvider);
    final itemId = widget.itemId;
    try {
      if (api == null) throw StateError('API unavailable for item refresh');
      final response = await api.getLibraryItemApi().getLibraryItem(
        itemId: itemId,
        extra: const <String, dynamic>{'doNotCache': true},
      );
      if (!mounted || widget.itemId != itemId || !identical(ref.read(absApiProvider), api)) return;
      final item = response.data;
      if (item == null) throw StateError('Item refresh returned no data');
      await processLibraryItemUpdate(
        container: ProviderScope.containerOf(context, listen: false),
        item: item,
        source: 'screen refresh',
      );
    } catch (e, s) {
      logger(
        'Failed to refresh item $itemId. Keeping existing item. Cause: $e\n$s',
        tag: 'LibraryItemView',
        level: InfoLevel.error,
      );
    }
  }

  @override
  void didUpdateWidget(covariant LibraryItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemId != widget.itemId || oldWidget.initialEditorTab != widget.initialEditorTab) {
      _didOpenInitialEditor = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemAsync = ref.watch(libraryItemProvider(widget.itemId, episodeId: widget.initialEpisodeId));
    final canDownload = ref.watch(currentUserProvider).value?.permissions.download ?? false;
    return itemAsync.when(
      data: (item) {
        final isPodcast = item.mediaType == 'podcast' || item.media?.podcastMedia != null;
        _scheduleInitialEditor(item, isPodcast: isPodcast);
        return ScreenRefreshIndicator(
          onRefresh: _refreshItem,
          child: isPodcast
              ? LibraryItemPodcastView(item: item, canDownload: canDownload, initialEpisodeId: widget.initialEpisodeId)
              : LibraryItemBookView(item: item, canDownload: canDownload),
        );
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
            ref.invalidate(libraryItemProvider(widget.itemId, episodeId: widget.initialEpisodeId));
            await ref.read(libraryItemProvider(widget.itemId, episodeId: widget.initialEpisodeId).future);
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
