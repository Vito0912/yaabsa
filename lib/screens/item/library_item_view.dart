import 'package:yaabsa/components/app/item/library_item_view_components.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/item_view_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LibraryItemView extends ConsumerWidget {
  const LibraryItemView(this.itemId, {super.key});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(libraryItemProvider(itemId));
    final api = ref.watch(absApiProvider);
    final canDownload = ref.watch(currentUserProvider).value?.permissions.download ?? false;
    return item.when(
      data: (item) {
        if (api == null) {
          return const Center(child: Text('No server connection available.'));
        }

        final bookMedia = item.media?.bookMedia;
        final metadata = bookMedia?.metadata;
        final hasAudio = item.media?.hasAudio ?? false;
        final hasBook = item.media?.hasBook ?? false;
        final audioFiles = bookMedia?.audioFiles ?? const [];
        final chapters = bookMedia?.chapters ?? const [];
        final ebookFile = bookMedia?.ebookFile;

        final durationSeconds = item.media?.duration() ?? 0;
        final duration = durationSeconds > 0 ? Duration(seconds: durationSeconds.round()) : null;
        final sizeBytes = bookMedia?.size ?? item.size;

        final horizontalPadding = context.isMobile
            ? 8.0
            : context.isTablet
            ? 16.0
            : 24.0;
        final isLargeScreen = !context.isMobile;
        final maxWidth = context.isDesktop
            ? 1120.0
            : context.isTablet
            ? 940.0
            : double.infinity;

        final metadataRows = buildItemMetadataRows(
          context,
          metadata: metadata,
          tags: bookMedia?.tags,
          duration: duration,
          sizeBytes: sizeBytes,
          onFilterTap: (filter) => openLibraryWithFilter(context, ref, filter: filter),
        );

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 16),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LibraryItemTopContent(
                    isLargeScreen: isLargeScreen,
                    title: item.title,
                    subtitle: item.subtitle,
                    cover: api.getLibraryItemApi().getLibraryItemCover(item.id, item: item),
                    actionButtons: buildItemActionButtons(
                      hasAudio: hasAudio,
                      hasBook: hasBook,
                      canDownload: canDownload,
                      onPlay: () {
                        audioHandler.setQueue(QueueItem(itemId: item.id));
                        audioHandler.play();
                      },
                      onRead: () {
                        context.push('/ebook/${item.id}');
                      },
                      onDownload: () {
                        downloadHandler.downloadFile(itemId);
                      },
                      onQueue: () {
                        audioHandler.addToQueue(QueueItem(itemId: item.id));
                      },
                    ),
                    metadataRows: metadataRows,
                    item: item,
                    onBack: () => context.pop(),
                  ),
                  LibraryItemMediaSections(
                    itemId: item.id,
                    chapters: chapters,
                    audioFiles: audioFiles,
                    ebookFile: ebookFile,
                    onChapterTap: (chapter) {
                      audioHandler.playItemFromPosition(
                        itemId: item.id,
                        position: Duration(seconds: chapter.start.round()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
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
