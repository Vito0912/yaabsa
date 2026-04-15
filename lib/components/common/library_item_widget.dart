import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LibraryItemWidget extends ConsumerWidget {
  const LibraryItemWidget(
    this.libraryItem,
    this.api, {
    super.key,
    this.showProgress = false,
    this.compact = false,
    this.squareCover = false,
  });

  final LibraryItem libraryItem;
  final ABSApi api;
  final bool showProgress;
  final bool compact;
  final bool squareCover;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = showProgress
        ? ref.watch(mediaProgressProvider.select((asyncValue) => asyncValue.value?[libraryItem.id]))
        : null;

    final progressValue = (progress?.progress ?? 0).clamp(0.0, 1.0).toDouble();
    final showProgressBar = showProgress && progressValue > 0;

    return Padding(
      padding: compact ? const EdgeInsets.all(4) : const EdgeInsets.all(8),
      child: InkWell(
        onTap: () async {
          context.push('/item/${libraryItem.id}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: squareCover
                      ? AspectRatio(aspectRatio: 1, child: api.getLibraryItemApi().getLibraryItemCover(libraryItem.id))
                      : SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: api.getLibraryItemApi().getLibraryItemCover(libraryItem.id),
                        ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.black),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (libraryItem.media!.hasAudio)
                          IconButton(
                            icon: const Icon(Icons.play_arrow, size: 14),
                            iconSize: 10,
                            onPressed: () {
                              audioHandler.setQueue(QueueItem(itemId: libraryItem.id));
                              audioHandler.play();
                            },
                            splashRadius: 8,
                          ),
                        if (!libraryItem.media!.hasAudio && libraryItem.media!.hasBook)
                          IconButton(
                            icon: const Icon(Icons.my_library_books_outlined, size: 14),
                            iconSize: 10,
                            onPressed: () {},
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (showProgressBar) ...[
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(value: progressValue, minHeight: compact ? 3.5 : 4),
              ),
            ],
            SizedBox(height: compact ? 6 : 8),
            Text(
              libraryItem.title,
              maxLines: compact ? 1 : 2,
              overflow: TextOverflow.ellipsis,
              style: compact ? Theme.of(context).textTheme.bodyMedium : null,
            ),
          ],
        ),
      ),
    );
  }
}
