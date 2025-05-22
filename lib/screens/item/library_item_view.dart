import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/provider/common/library_item_provider.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/util/globals.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Library Item')),
      body: item.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('No item found.'));
          }
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(width: 200, height: 200, child: api!.getLibraryItemApi().getLibraryItemCover(item.id)),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      audioHandler.setQueue(QueueItem(itemId: item.id));
                      audioHandler.play();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.book_outlined),
                    onPressed: () {
                      context.push('/ebook/${item.id}');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_to_photos_outlined),
                    onPressed: () {
                      audioHandler.addToQueue(QueueItem(itemId: item.id));
                    },
                  ),
                ],
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
