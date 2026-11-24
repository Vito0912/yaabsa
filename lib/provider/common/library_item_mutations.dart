part of 'library_item_provider.dart';

({LibraryItemState? state, bool reload}) _mutateLibraryItems(
  LibraryItemState currentLoadedState,
  LibraryItemMutation mutation, {
  required String libraryId,
}) {
  final stateLibraryId = currentLoadedState.libraryId ?? libraryId;
  final mutationLibraryId = mutation.libraryId?.trim();
  final hasLibraryMismatch =
      mutationLibraryId != null &&
      mutationLibraryId.isNotEmpty &&
      stateLibraryId.isNotEmpty &&
      mutationLibraryId != stateLibraryId;

  final existingIndex = currentLoadedState.items.indexWhere((item) => item.id == mutation.itemId);
  if (hasLibraryMismatch && existingIndex == -1) {
    return (state: null, reload: false);
  }

  if (currentLoadedState.filter == 'issues') {
    final item = mutation.item;
    final wasIssue = mutation.previousItem?.hasIssue ?? (existingIndex >= 0);
    final isIssue = item?.hasIssue ?? false;
    if (mutation.type != LibraryItemMutationType.updated || wasIssue != isIssue) {
      return (state: null, reload: true);
    }
  }

  final nextItems = List<LibraryItem>.from(currentLoadedState.items);
  var nextTotal = currentLoadedState.totalItems;
  var didChange = false;

  switch (mutation.type) {
    case LibraryItemMutationType.added:
      final item = mutation.item;
      if (item == null || hasLibraryMismatch) {
        return (state: null, reload: false);
      }

      if (existingIndex >= 0) {
        nextItems[existingIndex] = item;
        didChange = true;
        break;
      }

      if (!_shouldInsertAddedItem(currentLoadedState)) {
        return (state: null, reload: false);
      }

      nextItems.insert(0, item);
      nextTotal += 1;
      didChange = true;
      break;
    case LibraryItemMutationType.updated:
      final item = mutation.item;
      if (item == null || existingIndex == -1) {
        return (state: null, reload: false);
      }

      nextItems[existingIndex] = item;
      didChange = true;
      break;
    case LibraryItemMutationType.removed:
      if (existingIndex == -1) {
        return (state: null, reload: false);
      }

      nextItems.removeAt(existingIndex);
      nextTotal = nextTotal > 0 ? nextTotal - 1 : 0;
      didChange = true;
      break;
  }

  if (!didChange) {
    return (state: null, reload: false);
  }

  return (
    state: currentLoadedState.copyWith(
      items: nextItems,
      totalItems: nextTotal,
      hasNextPage: nextTotal > nextItems.length,
      error: null,
      stackTrace: null,
    ),
    reload: false,
  );
}

bool _shouldInsertAddedItem(LibraryItemState currentLoadedState) {
  final activeFilter = currentLoadedState.filter?.trim();
  if (activeFilter != null && activeFilter.isNotEmpty) {
    return false;
  }

  final activeSort = currentLoadedState.sort ?? defaultLibrarySortWireValue;
  final activeDesc = currentLoadedState.desc ?? defaultLibrarySortDesc;
  return activeSort == defaultLibrarySortWireValue && activeDesc == 1;
}
