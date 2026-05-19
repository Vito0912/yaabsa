import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/app/item/item_delete_actions.dart';
import 'package:yaabsa/components/app/item/item_progress_actions.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/components/app/library/library_multi_select_actions.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/multi_select_app_bar_provider.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';

import 'package:yaabsa/generated/l10n.dart';

class LibraryMultiSelectBindings {
  const LibraryMultiSelectBindings({
    required this.selectionMode,
    required this.selectedItemIds,
    required this.isBusy,
    required this.clearSelection,
    required this.enterSelectionById,
    required this.toggleSelectionById,
    required this.enterSelectionByIndex,
    required this.toggleSelectionByIndex,
  });

  final bool selectionMode;
  final Set<String> selectedItemIds;
  final bool isBusy;
  final VoidCallback clearSelection;
  final ValueChanged<String> enterSelectionById;
  final ValueChanged<String> toggleSelectionById;
  final ValueChanged<int> enterSelectionByIndex;
  final ValueChanged<int> toggleSelectionByIndex;
}

typedef LibraryMultiSelectViewBuilder = Widget Function(BuildContext context, LibraryMultiSelectBindings selection);

class LibraryMultiSelectHost extends HookConsumerWidget {
  const LibraryMultiSelectHost({
    required this.scopeKey,
    required this.libraryId,
    required this.visibleItems,
    required this.canAddToPlaylist,
    required this.canAddToCollection,
    required this.canQuickMatchItems,
    required this.canDeleteItems,
    required this.currentUserId,
    required this.builder,
    this.onAfterDelete,
    this.enableShiftRange = false,
    super.key,
  });

  final String scopeKey;
  final String libraryId;
  final List<LibraryItem> visibleItems;
  final bool canAddToPlaylist;
  final bool canAddToCollection;
  final bool canQuickMatchItems;
  final bool canDeleteItems;
  final String? currentUserId;
  final Future<void> Function()? onAfterDelete;
  final bool enableShiftRange;
  final LibraryMultiSelectViewBuilder builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SocketBatchQuickMatchComplete?>(socketBatchQuickMatchCompleteProvider, (previous, next) {
      if (next == null) {
        return;
      }

      if (previous?.timestamp == next.timestamp || !context.mounted) {
        return;
      }

      final message = next.success && next.updates > 0
          ? S.current.libraryMultiSelectMetadataChangeCompletedWithUpdates(next.updates)
          : S.current.libraryMultiSelectMetadataChangeCompleted;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    });

    final selectionMode = useState(false);
    final selectedItemIds = useState<Set<String>>(<String>{});
    final selectionAnchorIndex = useState<int?>(null);
    final selectionBusy = useState(false);

    void clearSelection() {
      selectionMode.value = false;
      selectionBusy.value = false;
      selectedItemIds.value = <String>{};
      selectionAnchorIndex.value = null;
    }

    useEffect(() {
      clearSelection();
      return null;
    }, <Object?>[scopeKey]);

    final itemIndexById = <String, int>{for (var i = 0; i < visibleItems.length; i++) visibleItems[i].id: i};
    final visibleIds = itemIndexById.keys.toSet();
    final effectiveSelectedItemIds = selectedItemIds.value.where(visibleIds.contains).toSet();

    if (effectiveSelectedItemIds.length != selectedItemIds.value.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectedItemIds.value = effectiveSelectedItemIds;
        if (effectiveSelectedItemIds.isEmpty) {
          selectionMode.value = false;
          selectionAnchorIndex.value = null;
        }
      });
    }

    int? resolveIndexForId(String itemId) => itemIndexById[itemId];

    void enterSelectionByIndex(int index) {
      if (index < 0 || index >= visibleItems.length || visibleItems[index].collapsedSeries != null) {
        return;
      }

      final next = Set<String>.from(effectiveSelectedItemIds)..add(visibleItems[index].id);
      selectedItemIds.value = next;
      selectionMode.value = true;
      selectionAnchorIndex.value = index;
    }

    void toggleSelectionByIndex(int index) {
      if (index < 0 || index >= visibleItems.length || visibleItems[index].collapsedSeries != null) {
        return;
      }

      final next = Set<String>.from(effectiveSelectedItemIds);
      final shiftPressed =
          enableShiftRange &&
          (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
              HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftRight));

      if (shiftPressed && selectionAnchorIndex.value != null) {
        final start = math.min(selectionAnchorIndex.value!, index);
        final end = math.max(selectionAnchorIndex.value!, index);

        for (var currentIndex = start; currentIndex <= end && currentIndex < visibleItems.length; currentIndex++) {
          final item = visibleItems[currentIndex];
          if (item.collapsedSeries != null) {
            continue;
          }
          next.add(item.id);
        }
      } else {
        final itemId = visibleItems[index].id;
        if (next.contains(itemId)) {
          next.remove(itemId);
        } else {
          next.add(itemId);
        }
      }

      if (next.isEmpty) {
        clearSelection();
        return;
      }

      selectedItemIds.value = next;
      selectionMode.value = true;
      selectionAnchorIndex.value = index;
    }

    void enterSelectionById(String itemId) {
      final index = resolveIndexForId(itemId);
      if (index == null) {
        return;
      }
      enterSelectionByIndex(index);
    }

    void toggleSelectionById(String itemId) {
      final index = resolveIndexForId(itemId);
      if (index == null) {
        return;
      }
      toggleSelectionByIndex(index);
    }

    final orderedSelectedBookIds = <String>[];
    final seen = <String>{};
    for (final item in visibleItems) {
      if (!effectiveSelectedItemIds.contains(item.id) || !seen.add(item.id)) {
        continue;
      }
      orderedSelectedBookIds.add(item.id);
    }
    final selectedIdsSignature = orderedSelectedBookIds.join(',');
    final selectedItems = visibleItems
        .where((item) => effectiveSelectedItemIds.contains(item.id))
        .toList(growable: false);
    final progressByKey = ref.watch(mediaProgressProvider).asData?.value ?? const <String, MediaProgress>{};
    final allSelectedFinished = areAllSupportedLibraryItemsFinished(selectedItems, progressByKey);
    final hasDeletableSelectedItems = selectedItems.any(isAudiobookLibraryItem);

    Future<void> runAction(Future<void> Function() action) async {
      if (selectionBusy.value) {
        return;
      }
      selectionBusy.value = true;
      try {
        await action();
      } finally {
        if (context.mounted) {
          selectionBusy.value = false;
        }
      }
    }

    final actions = <MultiSelectAppBarAction>[
      if (canAddToPlaylist)
        MultiSelectAppBarAction(
          icon: Icons.playlist_add_rounded,
          tooltip: S.current.componentsAppLibraryLibraryMultiSelectHostAddToPlaylist,
          enabled: !selectionBusy.value,
          onPressed: () {
            runAction(
              () => addSelectedBooksToPlaylist(
                context: context,
                ref: ref,
                libraryId: libraryId,
                currentUserId: currentUserId,
                selectedBookIds: orderedSelectedBookIds,
                onSuccess: clearSelection,
              ),
            );
          },
        ),
      if (canAddToCollection)
        MultiSelectAppBarAction(
          icon: Icons.collections_bookmark_outlined,
          tooltip: S.current.componentsAppLibraryLibraryMultiSelectHostAddToCollection,
          enabled: !selectionBusy.value,
          onPressed: () {
            runAction(
              () => addSelectedBooksToCollection(
                context: context,
                ref: ref,
                libraryId: libraryId,
                selectedBookIds: orderedSelectedBookIds,
                onSuccess: clearSelection,
              ),
            );
          },
        ),
      if (canQuickMatchItems)
        MultiSelectAppBarAction(
          icon: Icons.auto_fix_high_rounded,
          tooltip: S.current.componentsAppLibraryLibraryMultiSelectHostQuickMatchSelectedBooks,
          enabled: !selectionBusy.value,
          onPressed: () {
            runAction(
              () => quickMatchSelectedBooks(
                context: context,
                ref: ref,
                libraryId: libraryId,
                selectedBookIds: orderedSelectedBookIds,
                onSuccess: clearSelection,
              ),
            );
          },
        ),
      MultiSelectAppBarAction(
        icon: allSelectedFinished ? Icons.remove_done_rounded : Icons.task_alt_rounded,
        tooltip: allSelectedFinished ? 'Mark selected as unfinished' : 'Mark selected as finished',
        enabled: !selectionBusy.value,
        onPressed: () {
          runAction(() {
            if (allSelectedFinished) {
              return markLibraryItemsAsUnfinished(
                context: context,
                ref: ref,
                items: selectedItems,
                onSuccess: clearSelection,
              );
            }

            return markLibraryItemsAsFinished(
              context: context,
              ref: ref,
              items: selectedItems,
              onSuccess: clearSelection,
            );
          });
        },
      ),
      if (canDeleteItems)
        MultiSelectAppBarAction(
          icon: Icons.delete_outline_rounded,
          tooltip: hasDeletableSelectedItems ? 'Delete selected audiobooks' : 'No selected audiobooks can be deleted',
          enabled: !selectionBusy.value && hasDeletableSelectedItems,
          onPressed: () {
            runAction(() async {
              final deleted = await deleteAudiobooksInBulkWithConfirmation(
                context: context,
                ref: ref,
                selectedItems: selectedItems,
              );
              if (!deleted) {
                return;
              }

              clearSelection();
              if (onAfterDelete != null) {
                await onAfterDelete!();
              }
            });
          },
        ),
    ];

    final appBarNotifier = ref.read(multiSelectAppBarProvider.notifier);

    void scheduleAppBarSync() {
      Future<void>(() {
        if (!context.mounted) {
          return;
        }

        if (selectionMode.value && effectiveSelectedItemIds.isNotEmpty) {
          appBarNotifier.update(
            MultiSelectAppBarState(
              ownerKey: scopeKey,
              selectedCount: effectiveSelectedItemIds.length,
              actions: actions,
              isBusy: selectionBusy.value,
              onClearSelection: clearSelection,
            ),
          );
        } else {
          appBarNotifier.clearIfOwner(scopeKey);
        }
      });
    }

    void scheduleAppBarClearForScope() {
      appBarNotifier.clearIfOwner(scopeKey);
    }

    useEffect(
      () {
        scheduleAppBarSync();

        return null;
      },
      <Object?>[
        scopeKey,
        selectionMode.value,
        selectionBusy.value,
        selectedIdsSignature,
        allSelectedFinished,
        actions.length,
        canAddToPlaylist,
        canAddToCollection,
        canQuickMatchItems,
        currentUserId,
      ],
    );

    useEffect(() {
      return () {
        scheduleAppBarClearForScope();
      };
    }, <Object?>[scopeKey]);

    final bindings = LibraryMultiSelectBindings(
      selectionMode: selectionMode.value,
      selectedItemIds: effectiveSelectedItemIds,
      isBusy: selectionBusy.value,
      clearSelection: clearSelection,
      enterSelectionById: enterSelectionById,
      toggleSelectionById: toggleSelectionById,
      enterSelectionByIndex: enterSelectionByIndex,
      toggleSelectionByIndex: toggleSelectionByIndex,
    );

    return builder(context, bindings);
  }
}
