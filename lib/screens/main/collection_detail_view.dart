import 'dart:async';

import 'package:dio/dio.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/components/app/library/library_grid_layout_builder.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/list_entity_missing_view.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/features/library/widgets/managed_list_detail_frame.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/random_playback.dart';
import 'package:yaabsa/util/server_management_preferences.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';

class CollectionDetailView extends HookConsumerWidget {
  const CollectionDetailView({required this.collectionId, super.key, this.initialEntry, this.libraryId});

  final String collectionId;
  final String? libraryId;
  final MultiBookEntryData? initialEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    final serverReachable = ref.watch(serverStatusProvider).value ?? false;
    final libraryId = this.libraryId ?? selectedLibrary?.id;
    if (libraryId == null || libraryId.isEmpty) {
      return Center(child: Text(context.l10n.errorNoLibrarySelected));
    }

    final api = ref.watch(absApiProvider);
    if (api == null) {
      return ConnectionIssueView.offline();
    }

    final details = ref.watch(collectionByIdProvider(libraryId, collectionId));
    final resolvedCollection = details.hasError ? null : details.value;
    final resolvedEntry = _resolveEntry(collectionId, initialEntry, resolvedCollection);

    if (resolvedCollection == null) {
      if (details.isLoading) {
        return const Center(child: YaabsaCircularProgressIndicator());
      }
      final error = details.error;
      final missing = error is DioException && error.response?.statusCode == 404;
      if (details.hasError && !missing) {
        if (!serverReachable) {
          return ConnectionIssueView.offline(
            onRetry: () => ref.refresh(collectionByIdProvider(libraryId, collectionId).future),
          );
        }

        return ConnectionIssueView.requestFailed(
          error: details.error ?? Exception(context.l10n.errorUnableToLoadContent),
          title: context.l10n.errorCollectionUnavailable,
          onRetry: () => ref.refresh(collectionByIdProvider(libraryId, collectionId).future),
        );
      }

      return ListEntityMissingView(
        icon: Icons.collections_bookmark_outlined,
        title: context.l10n.errorCollectionMissing,
        message: context.l10n.statusListMayBeRemoved,
      );
    }

    final collectionItems = resolvedCollection.items ?? const [];
    final currentUser = ref.watch(currentUserProvider).value;
    ref.watch(userSettingsWatcherProvider);
    final managementPreferences = readServerManagementPreferences(ref, currentUser?.id);
    final collectionsManagementEnabled = managementPreferences.collectionsEnabled;
    final hasCollectionManagementPermission = currentUser?.permissions.update ?? false;
    final canEditCollection = hasCollectionManagementPermission && collectionsManagementEnabled;
    final canDeleteCollection = hasCollectionManagementPermission && collectionsManagementEnabled;
    final showShuffleButton =
        currentUser != null &&
        ref
            .read(settingsManagerProvider.notifier)
            .getUserSetting<bool>(currentUser.id, SettingKeys.showShuffleButton, defaultValue: false);
    final description = resolvedCollection.description?.trim();

    return LibraryGridLayoutBuilder(
      builder: (context, _, tileWidth, _) => ManagedListDetailFrame(
        title: resolvedEntry?.title ?? resolvedCollection.name,
        description: description,
        emptyTitle: context.l10n.statusNoItemsInManagedList,
        emptyMessage: context.l10n.promptAddItemsToManagedList,
        emptyIcon: Icons.collections_bookmark_outlined,
        scrollController: scrollController,
        tileWidth: tileWidth,
        onRefresh: () => ref.refresh(collectionByIdProvider(libraryId, collectionId).future).then<void>((_) {}),
        itemCount: collectionItems.length,
        itemBuilder: (context, index) {
          final item = collectionItems[index];
          return LibraryItemWidget(
            item,
            api,
            showProgress: true,
            squareCover: true,
            onPlay: () {
              audioHandler.playLibraryItem(
                item,
                autoQueueStart: AutoQueueStart(
                  type: AutoQueueStartType.collection,
                  sourceId: collectionId,
                  globalIndex: index,
                ),
              );
            },
          );
        },
        headerActions: Wrap(
          spacing: 0,
          children: [
            if (showShuffleButton && hasRandomPlaybackTarget(collectionItems))
              IconButton(
                onPressed: () => unawaited(
                  playRandomLibraryItemOrEpisode(
                    collectionItems,
                    sourceType: AutoQueueStartType.collection,
                    sourceId: collectionId,
                  ),
                ),
                icon: const Icon(Icons.shuffle_rounded),
                tooltip: context.l10n.actionPlayRandomItem,
              ),
            if (canEditCollection || canDeleteCollection)
              YaabsaContextMenuButton<_CollectionDetailAction>(
                tooltip: context.l10n.actionMore,
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
                      PopupMenuItem<_CollectionDetailAction>(
                        value: _CollectionDetailAction.editBooks,
                        child: Text(context.l10n.actionEditBooks),
                      ),
                    );
                    items.add(
                      PopupMenuItem<_CollectionDetailAction>(
                        value: _CollectionDetailAction.edit,
                        child: Text(context.l10n.actionEditDetails),
                      ),
                    );
                  }
                  if (canDeleteCollection) {
                    items.add(
                      PopupMenuItem<_CollectionDetailAction>(
                        value: _CollectionDetailAction.delete,
                        child: Text(context.l10n.actionDelete),
                      ),
                    );
                  }

                  return items;
                },
              ),
          ],
        ),
      ),
    );
  }
}

MultiBookEntryData? _resolveEntry(String collectionId, MultiBookEntryData? initialEntry, Collection? collection) {
  if (collection != null) {
    return MultiBookEntryData.fromCollection(collection);
  }

  return initialEntry?.id == collectionId ? initialEntry : null;
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
    title: context.l10n.actionEditBooks,
    confirmLabel: context.l10n.actionSaveBooks,
    selectionRequired: true,
    initialBooks: collectionItems,
    onSave: (bookIds) => ref
        .read(collectionsProvider(libraryId).notifier)
        .replaceBooksInCollection(
          collection.id,
          currentBookIds: collectionItems.map((item) => item.id).toList(growable: false),
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
    popOnSuccess: true,
  );
}

enum _CollectionDetailAction { editBooks, edit, delete }
