import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        if (isPodcast) {
          return LibraryItemPodcastView(item: item, canDownload: canDownload);
        }

        return LibraryItemBookView(item: item, canDownload: canDownload);
      },
      error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
