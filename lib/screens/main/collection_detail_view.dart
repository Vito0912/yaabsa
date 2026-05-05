import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/list_entity_missing_view.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
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
      return ConnectionIssueView.offline();
    }

    final libraryId = selectedLibrary.id;
    final allCollectionsAsync = ref.watch(collectionsProvider(libraryId));
    final resolvedCollection = _resolveCollection(collectionId, allCollectionsAsync.value?.items);
    final resolvedEntry = _resolveEntry(collectionId, initialEntry, resolvedCollection);

    if (resolvedCollection == null) {
      if (allCollectionsAsync.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (allCollectionsAsync.hasError) {
        return ConnectionIssueView.requestFailed(
          error: allCollectionsAsync.error ?? Exception('Unknown collection loading error.'),
          title: 'Collection details could not be loaded',
          onRetry: () => ref.read(collectionsProvider(libraryId).notifier).refresh(withLoading: true),
        );
      }

      return const ListEntityMissingView(
        icon: Icons.collections_bookmark_outlined,
        title: 'Collection is no longer available',
        message: 'It may have been deleted from this library.',
      );
    }

    final collectionItems = resolvedCollection.items ?? const [];
    final currentUser = ref.watch(currentUserProvider).value;
    final canEditCollection = currentUser?.permissions.update ?? false;
    final canDeleteCollection = currentUser?.permissions.delete ?? false;
    final description = resolvedCollection.description?.trim();

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridLayout = appCenteredGridLayout(constraints.maxWidth);
        final horizontalPadding = gridLayout.horizontalPadding;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
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
                  if (canEditCollection || canDeleteCollection)
                    PopupMenuButton<_CollectionDetailAction>(
                      tooltip: 'Collection actions',
                      onSelected: (action) => _handleCollectionAction(
                        context: context,
                        ref: ref,
                        libraryId: libraryId,
                        collection: resolvedCollection,
                        action: action,
                      ),
                      itemBuilder: (context) {
                        final items = <PopupMenuEntry<_CollectionDetailAction>>[];
                        if (canEditCollection) {
                          items.add(
                            const PopupMenuItem<_CollectionDetailAction>(
                              value: _CollectionDetailAction.editBooks,
                              child: Text('Edit books'),
                            ),
                          );
                          items.add(
                            const PopupMenuItem<_CollectionDetailAction>(
                              value: _CollectionDetailAction.edit,
                              child: Text('Edit details'),
                            ),
                          );
                        }
                        if (canDeleteCollection) {
                          items.add(
                            const PopupMenuItem<_CollectionDetailAction>(
                              value: _CollectionDetailAction.delete,
                              child: Text('Delete collection'),
                            ),
                          );
                        }

                        return items;
                      },
                    ),
                ],
              ),
            ),
            if (description != null && description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                            final item = collectionItems[index];
                            return LibraryItemWidget(
                              item,
                              api,
                              showProgress: true,
                              squareCover: true,
                              onPlay: () {
                                audioHandler.playLibraryItemFromCollectionView(
                                  item,
                                  libraryId: libraryId,
                                  collectionId: collectionId,
                                  itemIndex: index,
                                );
                              },
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

Future<void> _handleCollectionAction({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Collection collection,
  required _CollectionDetailAction action,
}) async {
  switch (action) {
    case _CollectionDetailAction.editBooks:
      await _editCollectionBooks(context: context, ref: ref, libraryId: libraryId, collection: collection);
      break;
    case _CollectionDetailAction.edit:
      await _editCollection(context: context, ref: ref, libraryId: libraryId, collection: collection);
      break;
    case _CollectionDetailAction.delete:
      await _deleteCollection(context: context, ref: ref, libraryId: libraryId, collection: collection);
      break;
  }
}

Future<void> _editCollectionBooks({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Collection collection,
}) async {
  final collectionItems = collection.items ?? const <LibraryItem>[];
  await editManagedListBooks(
    context: context,
    title: 'Edit books',
    confirmLabel: 'Save books',
    selectionRequired: true,
    initialBooks: collectionItems,
    onSave: (bookIds) => ref
        .read(collectionsProvider(libraryId).notifier)
        .replaceBooksInCollection(
          collection.id,
          currentBookIds: collectionItems.map((item) => item.id).toList(growable: false),
          desiredBookIds: bookIds,
        ),
    successMessage: 'Collection books updated.',
    errorFallback: 'Could not update collection books.',
  );
}

Future<void> _editCollection({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Collection collection,
}) async {
  await editManagedListDetails(
    context: context,
    title: 'Edit collection',
    initialName: collection.name,
    initialDescription: collection.description,
    onSave: ({required name, description}) => ref
        .read(collectionsProvider(libraryId).notifier)
        .updateCollection(collection.id, name: name, description: description),
    successMessage: 'Collection updated.',
    errorFallback: 'Could not update collection.',
  );
}

Future<void> _deleteCollection({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Collection collection,
}) async {
  await deleteManagedListEntity(
    context: context,
    title: 'Delete collection?',
    message: '"${collection.name}" will be permanently removed.',
    onDelete: () => ref.read(collectionsProvider(libraryId).notifier).deleteCollection(collection.id),
    successMessage: 'Collection deleted.',
    errorFallback: 'Could not delete collection.',
    popOnSuccess: true,
  );
}

enum _CollectionDetailAction { editBooks, edit, delete }
