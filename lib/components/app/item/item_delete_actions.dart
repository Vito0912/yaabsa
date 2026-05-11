import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/common/library_item_delete_dialog.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/library/personalized_library_provider.dart';

void invalidateLibraryItemLists(WidgetRef ref) {
  ref.invalidate(libraryItemsProvider);
  ref.invalidate(personalizedLibraryProvider);
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Only audiobooks can be deleted from this action.')));
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
        ? 'Deleted "${item.title}" from Audiobookshelf and file system.'
        : 'Deleted "${item.title}" from Audiobookshelf.',
    errorFallback: 'Could not delete audiobook.',
    popOnSuccess: popOnSuccess,
    onSuccess: () {
      didDelete = true;
      invalidateLibraryItemLists(ref);
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No selected audiobooks can be deleted. Select audiobook items and try again.')),
    );
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
        ? 'Deleted ${deleteIds.length} audiobook(s) from Audiobookshelf and file system.'
        : 'Deleted ${deleteIds.length} audiobook(s) from Audiobookshelf.',
    errorFallback: 'Could not delete selected audiobooks.',
    onSuccess: () {
      didDelete = true;
      invalidateLibraryItemLists(ref);
      onSuccess?.call();
    },
  );

  return didDelete;
}
