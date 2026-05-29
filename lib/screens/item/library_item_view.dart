import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/item/library_item_book_view.dart';
import 'package:yaabsa/screens/item/library_item_podcast_view.dart';

class LibraryItemView extends ConsumerWidget {
  const LibraryItemView(this.itemId, {super.key});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(libraryItemProvider(itemId));
    final canDownload = ref.watch(currentUserProvider).value?.permissions.download ?? false;
    return itemAsync.when(
      data: (item) {
        final isPodcast = item.mediaType == 'podcast' || item.media?.podcastMedia != null;
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
            ref.invalidate(libraryItemProvider(itemId));
            await ref.read(libraryItemProvider(itemId).future);
          },
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

bool _isNotFoundError(Object error) {
  final message = error.toString().toLowerCase();
  return message.contains('404') || message.contains('not found');
}
