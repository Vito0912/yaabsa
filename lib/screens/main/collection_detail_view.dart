import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/layout_sizes.dart';

class CollectionDetailView extends HookConsumerWidget {
  const CollectionDetailView({required this.collectionId, super.key, this.initialEntry});

  final String collectionId;
  final MultiBookEntryData? initialEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    final api = ref.watch(absApiProvider);
    if (api == null) {
      return const Center(child: Text('No server connection available.'));
    }

    final libraryId = selectedLibrary.id;
    final allCollectionsAsync = ref.watch(collectionsProvider(libraryId));
    final resolvedCollection = _resolveCollection(collectionId, allCollectionsAsync.value?.items);
    final resolvedEntry = _resolveEntry(collectionId, initialEntry, resolvedCollection);

    if (resolvedCollection == null) {
      if (allCollectionsAsync.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return const Center(child: Text('Collection details could not be loaded.'));
    }

    final collectionItems = resolvedCollection.items ?? const [];

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridLayout = appCenteredGridLayout(constraints.maxWidth);
        final horizontalPadding = gridLayout.horizontalPadding;
        final subtitle = _resolveSubtitle(resolvedEntry, collectionItems.length);

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 10, horizontalPadding, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: 'Back',
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      resolvedEntry?.title ?? resolvedCollection.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding + 58, 0, horizontalPadding, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            if (collectionItems.isEmpty)
              const Expanded(child: Center(child: Text('No books found in this collection.')))
            else
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: RefreshIndicator(
                        onRefresh: () => ref.read(collectionsProvider(libraryId).notifier).refresh(withLoading: false),
                        child: AlignedGridView.count(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
                          crossAxisCount: gridLayout.crossAxisCount,
                          mainAxisSpacing: appGridSpacing,
                          crossAxisSpacing: appGridSpacing,
                          itemCount: collectionItems.length,
                          itemBuilder: (context, index) {
                            return LibraryItemWidget(
                              collectionItems[index],
                              api,
                              showProgress: true,
                              squareCover: true,
                            );
                          },
                        ),
                      ),
                    ),
                    ScrollToTopButton(controller: scrollController),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

Collection? _resolveCollection(String collectionId, List<Collection>? allCollections) {
  if (allCollections == null) return null;

  for (final collection in allCollections) {
    if (collection.id == collectionId) {
      return collection;
    }
  }

  return null;
}

MultiBookEntryData? _resolveEntry(String collectionId, MultiBookEntryData? initialEntry, Collection? collection) {
  if (initialEntry != null && initialEntry.id == collectionId) {
    return initialEntry;
  }

  if (collection != null) {
    return MultiBookEntryData.fromCollection(collection);
  }

  return initialEntry;
}

String? _resolveSubtitle(MultiBookEntryData? entry, int itemCount) {
  if (entry != null && entry.subtitle != null && entry.subtitle!.isNotEmpty) {
    return entry.subtitle;
  }

  if (itemCount > 0) {
    return '$itemCount books';
  }

  return null;
}
