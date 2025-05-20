import 'package:buchshelfly/api/library_items/library_item.dart';
import 'package:buchshelfly/api/routes/abs_api.dart';
import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/provider/common/media_progress_provider.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryItemWidget extends HookWidget {
  const LibraryItemWidget(
    this.libraryItem,
    this.api, {
    super.key,
    this.showProgress = false,
  });

  final LibraryItem libraryItem;
  final ABSApi api;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    // Use a hook for hover state
    final isHovered = useState(false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: api.getLibraryItemApi().getLibraryItemCover(
                      libraryItem.id,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: MouseRegion(
                    onEnter: (_) => isHovered.value = true,
                    onExit: (_) => isHovered.value = false,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (showProgress)
                            Consumer(
                              builder: (
                                BuildContext context,
                                WidgetRef ref,
                                Widget? child,
                              ) {
                                final progress = ref.watch(
                                  mediaProgressNotifierProvider.select((
                                    asyncValue,
                                  ) {
                                    return asyncValue.value?[libraryItem.id];
                                  }),
                                );
                                return CircularProgressIndicator(
                                  value: progress?.progress ?? 0,
                                  strokeWidth: 2,
                                  constraints: const BoxConstraints(
                                    minWidth: 25,
                                    minHeight: 25,
                                  ),
                                  backgroundColor: Colors.white,
                                  color: Colors.blue,
                                  year2023: false,
                                );
                              },
                            ),
                          if (isHovered.value && libraryItem.media!.hasAudio)
                            IconButton(
                              icon: const Icon(Icons.play_arrow, size: 14),
                              iconSize: 10,
                              onPressed: () {
                                audioHandler.setQueue(
                                  QueueItem(itemId: libraryItem.id),
                                );
                                audioHandler.play();
                              },
                              splashRadius: 8,
                            ),
                          if (isHovered.value &&
                              !libraryItem.media!.hasAudio &&
                              libraryItem.media!.hasBook)
                            IconButton(
                              icon: const Icon(
                                Icons.my_library_books_outlined,
                                size: 14,
                              ),
                              iconSize: 10,
                              onPressed: () {},
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              libraryItem.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
