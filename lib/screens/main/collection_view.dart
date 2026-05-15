import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/components/common/managed_multi_book_view.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/server_management_preferences.dart';

class CollectionView extends HookConsumerWidget {
  const CollectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    final serverReachable = ref.watch(serverStatusProvider).value ?? false;

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    final libraryId = selectedLibrary.id;
    final api = ref.watch(absApiProvider);
    if (api == null) {
      return ConnectionIssueView.offline();
    }

    final currentUser = ref.watch(currentUserProvider).value;
    ref.watch(userSettingsWatcherProvider);
    final managementPreferences = readServerManagementPreferences(ref, currentUser?.id);
    final collectionsManagementEnabled = managementPreferences.collectionsEnabled;
    final hasCollectionManagementPermission = currentUser?.permissions.update ?? false;
    final canEditCollections = hasCollectionManagementPermission && collectionsManagementEnabled;
    final canDeleteCollections = hasCollectionManagementPermission && collectionsManagementEnabled;
    final canCreateCollections = canEditCollections && selectedLibrary.mediaType == 'book';

    final collectionStateAsync = ref.watch(collectionsProvider(libraryId));

    return collectionStateAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (state) {
        final collections = state.items;
        final cards = collections
            .map(
              (collection) => ManagedMultiBookCardConfig(
                entry: MultiBookEntryData.fromCollection(collection),
                onTap: () {
                  context.push('/collection/${collection.id}', extra: MultiBookEntryData.fromCollection(collection));
                },
                onLongPress: (canEditCollections || canDeleteCollections)
                    ? () => _showCollectionActionsSheet(
                        context: context,
                        ref: ref,
                        libraryId: libraryId,
                        collection: collection,
                        canEditCollections: canEditCollections,
                        canDeleteCollections: canDeleteCollections,
                      )
                    : null,
              ),
            )
            .toList(growable: false);

        return ManagedMultiBookView(
          title: 'Collections',
          createLabel: 'New collection',
          emptyTitle: 'No collections yet.',
          emptyMessage: 'Create one to group books you want to revisit together.',
          onCreate: canCreateCollections
              ? () => _createCollection(context: context, ref: ref, libraryId: libraryId)
              : null,
          scrollController: scrollController,
          api: api,
          cards: cards,
          onRefresh: () => ref.read(collectionsProvider(libraryId).notifier).refresh(withLoading: false),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        if (!serverReachable) {
          return ConnectionIssueView.offline(
            onRetry: () => ref.read(collectionsProvider(libraryId).notifier).refresh(withLoading: true),
          );
        }

        return ConnectionIssueView.requestFailed(
          error: error,
          title: 'Error loading collections',
          onRetry: () => ref.read(collectionsProvider(libraryId).notifier).refresh(withLoading: true),
        );
      },
    );
  }
}

Future<void> _showCollectionActionsSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Collection collection,
  required bool canEditCollections,
  required bool canDeleteCollections,
}) async {
  final selectedAction = await showModalBottomSheet<_CollectionAction>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(collection.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
            const Divider(height: 1),
            if (canEditCollections)
              ListTile(
                leading: const Icon(Icons.menu_book_rounded),
                title: const Text('Edit books'),
                onTap: () => Navigator.of(sheetContext).pop(_CollectionAction.editBooks),
              ),
            if (canEditCollections)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit details'),
                onTap: () => Navigator.of(sheetContext).pop(_CollectionAction.edit),
              ),
            if (canDeleteCollections)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Delete collection'),
                onTap: () => Navigator.of(sheetContext).pop(_CollectionAction.delete),
              ),
          ],
        ),
      );
    },
  );

  if (!context.mounted || selectedAction == null) {
    return;
  }

  switch (selectedAction) {
    case _CollectionAction.editBooks:
      await _editCollectionBooks(context: context, ref: ref, libraryId: libraryId, collection: collection);
      break;
    case _CollectionAction.edit:
      await _editCollection(context: context, ref: ref, libraryId: libraryId, collection: collection);
      break;
    case _CollectionAction.delete:
      await _deleteCollection(context: context, ref: ref, libraryId: libraryId, collection: collection);
      break;
  }
}

Future<void> _createCollection({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
}) async {
  await createManagedListEntity(
    context: context,
    formTitle: 'Create collection',
    booksTitle: 'Edit books',
    createLabel: 'Create',
    selectionRequired: true,
    onCreate: ({required name, description, required bookIds}) {
      return ref
          .read(collectionsProvider(libraryId).notifier)
          .createCollection(name: name, description: description, bookIds: bookIds);
    },
    successMessage: 'Collection created.',
    errorFallback: 'Could not create collection.',
  );
}

Future<void> _editCollectionBooks({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Collection collection,
}) async {
  final currentBooks = collection.items ?? const <LibraryItem>[];

  await editManagedListBooks(
    context: context,
    title: 'Edit books',
    confirmLabel: 'Save books',
    selectionRequired: true,
    initialBooks: currentBooks,
    onSave: (bookIds) => ref
        .read(collectionsProvider(libraryId).notifier)
        .replaceBooksInCollection(
          collection.id,
          currentBookIds: currentBooks.map((item) => item.id).toList(growable: false),
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
  );
}

enum _CollectionAction { editBooks, edit, delete }
