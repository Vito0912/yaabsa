import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/layout_sizes.dart';

class CollectionView extends ConsumerWidget {
  const CollectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    final libraryId = selectedLibrary.id;
    final api = ref.watch(absApiProvider);
    if (api == null) {
      return const Center(child: Text('No server connection available.'));
    }

    final collectionStateAsync = ref.watch(collectionsProvider(libraryId));

    return collectionStateAsync.when(
      data: (state) {
        final collections = state.items;
        if (collections.isEmpty) {
          return const Center(child: Text('No collections found in this library.'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final gridLayout = appCenteredGridLayout(constraints.maxWidth, tileWidth: appGridTileWidth * 1.5);

            return RefreshIndicator(
              onRefresh: () => ref.read(collectionsProvider(libraryId).notifier).refresh(withLoading: false),
              child: AlignedGridView.count(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(gridLayout.horizontalPadding, 12, gridLayout.horizontalPadding, 16),
                crossAxisCount: gridLayout.crossAxisCount,
                mainAxisSpacing: appGridSpacing,
                crossAxisSpacing: appGridSpacing,
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  final collection = collections[index];
                  final collectionEntry = MultiBookEntryData.fromCollection(collection);

                  return MultiBookEntryWidget(
                    api: api,
                    entry: collectionEntry,
                    compact: constraints.maxWidth < 700,
                    squareCover: true,
                    coverHeight: appGridTileWidth,
                    showSubtitle: true,
                    maxBooksToShow: defaultMultiBookPreviewLimit,
                    onTap: () {
                      context.push('/collection/${collection.id}', extra: collectionEntry);
                    },
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error loading collections: $error')),
    );
  }
}
