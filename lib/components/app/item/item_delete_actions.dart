import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/common/library_item_delete_dialog.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/provider/common/library_item_sync.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/l10n.dart';

void removeLibraryItemsLocally(WidgetRef ref, Iterable<LibraryItem> removedItems) {
  for (final removedItem in removedItems) {
    unawaited(processLibraryItemRemoved(container: ref.container, item: removedItem, source: 'item_delete_actions'));
  }
}

bool isAudiobookLibraryItem(LibraryItem item) {
  return item.mediaType == 'book' || item.media?.bookMedia != null;
}

bool canDeleteAudiobook({required LibraryItem item, required bool hasDeletePermission}) {
  return hasDeletePermission && isAudiobookLibraryItem(item);
}

List<LibraryItem> collectUniqueDeletableAudiobooks(Iterable<LibraryItem> items) {
  final seenIds = <String>{};
  final deletableItems = <LibraryItem>[];

  for (final item in items) {
    if (!isAudiobookLibraryItem(item) || !seenIds.add(item.id)) {
      continue;
    }
    deletableItems.add(item);
  }

  return deletableItems;
}

int countUniqueLibraryItems(Iterable<LibraryItem> items) {
  final seenIds = <String>{};
  for (final item in items) {
    seenIds.add(item.id);
  }
  return seenIds.length;
}

Future<bool> deleteAudiobookWithConfirmation({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
  bool popOnSuccess = false,
  VoidCallback? onSuccess,
}) async {
  if (!isAudiobookLibraryItem(item)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.errorOnlyAudiobooksCanBeDeletedHere)));
    return false;
  }

  final deleteMode = await showLibraryItemDeleteDialog(context: context, deleteCount: 1);
  if (!context.mounted || deleteMode == null) {
    return false;
  }

  final hardDelete = deleteMode == LibraryItemDeleteMode.absAndFileSystem;

  var didDelete = false;
  await runManagedListMutation(
    context: context,
    action: () async {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw Exception('API not available');
      }

      final deleted = await api.getLibraryItemApi().deleteLibraryItem(item.id, hardDelete: hardDelete);
      if (!deleted) {
        throw Exception('Delete request failed.');
      }
    },
    successMessage: hardDelete
        ? context.l10n.statusAudiobookDeletedFromServerAndFileSystem(item.title)
        : context.l10n.statusAudiobookDeletedFromServer(item.title),
    errorFallback: context.l10n.errorDeleteAudiobookFailed,
    popOnSuccess: popOnSuccess,
    onSuccess: () {
      didDelete = true;
      removeLibraryItemsLocally(ref, <LibraryItem>[item]);
      onSuccess?.call();
    },
  );

  return didDelete;
}

Future<bool> deleteAudiobooksInBulkWithConfirmation({
  required BuildContext context,
  required WidgetRef ref,
  required List<LibraryItem> selectedItems,
  VoidCallback? onSuccess,
}) async {
  final uniqueSelectedCount = countUniqueLibraryItems(selectedItems);
  final deletableItems = collectUniqueDeletableAudiobooks(selectedItems);

  if (deletableItems.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.errorNoSelectedAudiobooksCanBeDeleted)));
    return false;
  }

  final skippedCount = uniqueSelectedCount - deletableItems.length;
  final deleteMode = await showLibraryItemDeleteDialog(
    context: context,
    deleteCount: deletableItems.length,
    skippedCount: skippedCount,
  );

  if (!context.mounted || deleteMode == null) {
    return false;
  }

  final hardDelete = deleteMode == LibraryItemDeleteMode.absAndFileSystem;
  final deleteIds = deletableItems.map((item) => item.id).toList(growable: false);

  var didDelete = false;
  await runManagedListMutation(
    context: context,
    action: () async {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw Exception('API not available');
      }

      final deleted = await api.getLibraryItemApi().deleteLibraryItems(deleteIds, hardDelete: hardDelete);
      if (!deleted) {
        throw Exception('Bulk delete request failed.');
      }
    },
    successMessage: hardDelete
        ? context.l10n.statusSelectedAudiobooksDeletedFromServerAndFileSystem(deleteIds.length)
        : context.l10n.statusSelectedAudiobooksDeletedFromServer(deleteIds.length),
    errorFallback: context.l10n.errorDeleteSelectedAudiobooksFailed,
    onSuccess: () {
      didDelete = true;
      removeLibraryItemsLocally(ref, deletableItems);
      onSuccess?.call();
    },
  );

  return didDelete;
}
