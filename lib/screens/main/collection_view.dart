import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/components/common/managed_multi_book_view.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/loading_view.dart';
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
      return Center(child: Text(context.l10n.errorNoLibrarySelected));
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
          createLabel: context.l10n.actionCreateCollection,
          emptyTitle: context.l10n.statusNoManagedLists,
          emptyMessage: context.l10n.promptCreateManagedList,
          emptyIcon: Icons.collections_bookmark_outlined,
          onCreate: canCreateCollections
              ? () => _createCollection(context: context, ref: ref, libraryId: libraryId)
              : null,
          scrollController: scrollController,
          api: api,
          cards: cards,
          hasNextPage: state.hasNextPage,
          isLoadingNextPage: state.isLoadingNextPage,
          nextPageError: state.nextPageError ?? state.error,
          refreshError: state.error,
          onLoadMore: () {
            final notifier = ref.read(collectionsProvider(libraryId).notifier);
            if (state.error != null) {
              notifier.refresh(withLoading: false, requireServer: true);
            } else {
              notifier.loadNextPage();
            }
          },
          onRefresh: () => ref.read(collectionsProvider(libraryId).notifier).refresh(withLoading: false),
        );
      },
      loading: () => const LoadingView(),
      error: (error, stackTrace) {
        if (!serverReachable) {
          return ConnectionIssueView.offline(
            onRetry: () => ref.read(collectionsProvider(libraryId).notifier).refresh(withLoading: true),
          );
        }

        return ConnectionIssueView.requestFailed(
          error: error,
          title: context.l10n.errorUnableToLoadContent,
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
                title: Text(context.l10n.actionEditBooks),
                onTap: () => Navigator.of(sheetContext).pop(_CollectionAction.editBooks),
              ),
            if (canEditCollections)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(context.l10n.actionEditDetails),
                onTap: () => Navigator.of(sheetContext).pop(_CollectionAction.edit),
              ),
            if (canDeleteCollections)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: Text(context.l10n.actionDelete),
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
    formTitle: context.l10n.actionCreateCollection,
    booksTitle: context.l10n.actionEditBooks,
    createLabel: context.l10n.actionCreate,
    selectionRequired: true,
    onCreate: ({required name, description, required bookIds}) async {
      final created = await ref
          .read(collectionsProvider(libraryId).notifier)
          .createCollection(name: name, description: description, bookIds: bookIds);
      if (!context.mounted) {
        return;
      }

      context.push(
        Uri(path: '/collection/${created.id}', queryParameters: {'libraryId': libraryId}).toString(),
        extra: MultiBookEntryData.fromCollection(created),
      );
    },
    successMessage: context.l10n.statusNamedEntityCreated(context.l10n.fieldCollection),
    errorFallback: context.l10n.errorNamedEntityCreateFailed(context.l10n.fieldCollection),
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
    title: context.l10n.actionEditBooks,
    confirmLabel: context.l10n.actionSaveBooks,
    selectionRequired: true,
    initialBooks: currentBooks,
    onSave: (bookIds) => ref
        .read(collectionsProvider(libraryId).notifier)
        .replaceBooksInCollection(
          collection.id,
          currentBookIds: currentBooks.map((item) => item.id).toList(growable: false),
          desiredBookIds: bookIds,
        ),
    successMessage: context.l10n.statusNamedBooksUpdated(context.l10n.fieldCollection),
    errorFallback: context.l10n.errorNamedBooksUpdateFailed(context.l10n.fieldCollection),
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
    title: context.l10n.editNamedEntity(context.l10n.fieldCollection),
    initialName: collection.name,
    initialDescription: collection.description,
    onSave: ({required name, description}) => ref
        .read(collectionsProvider(libraryId).notifier)
        .updateCollection(collection.id, name: name, description: description),
    successMessage: context.l10n.statusNamedEntityUpdated(context.l10n.fieldCollection),
    errorFallback: context.l10n.errorNamedEntityUpdateFailed(context.l10n.fieldCollection),
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
    title: context.l10n.headingDeleteManagedList,
    message: context.l10n.deleteNamedEntityMessage(collection.name),
    onDelete: () => ref.read(collectionsProvider(libraryId).notifier).deleteCollection(collection.id),
    successMessage: context.l10n.statusNamedEntityDeleted(context.l10n.fieldCollection),
    errorFallback: context.l10n.errorNamedEntityDeleteFailed(context.l10n.fieldCollection),
  );
}

enum _CollectionAction { editBooks, edit, delete }
