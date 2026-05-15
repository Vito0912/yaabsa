import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_overlay.dart';
import 'package:yaabsa/components/app/library/library_filter_toolbar.dart';
import 'package:yaabsa/components/app/library/library_items_grid.dart';
import 'package:yaabsa/components/app/library/library_multi_select_host.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/server_management_preferences.dart';
import 'package:yaabsa/util/setting_key.dart';

class LibraryView extends HookConsumerWidget {
  const LibraryView({super.key, this.initialFilter});

  final String? initialFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final editingItemId = useState<String?>(null);
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    final serverReachable = ref.watch(serverStatusProvider).value ?? false;

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    final appDatabase = ref.watch(appDatabaseProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    ref.watch(userSettingsWatcherProvider);
    final managementPreferences = readServerManagementPreferences(ref, currentUser?.id);
    final collapseSeriesFallback = currentUser == null
        ? false
        : ref
              .read(settingsManagerProvider.notifier)
              .getUserSetting<bool>(currentUser.id, SettingKeys.collapseSeries, defaultValue: false);

    final String libraryId = selectedLibrary.id;
    final filterDataAsync = ref.watch(libraryFilterDataProvider(libraryId));

    final api = ref.watch(absApiProvider);
    if (api == null) {
      return ConnectionIssueView.offline();
    }

    return StreamBuilder<UserSettingEntry?>(
      stream: currentUser == null ? null : appDatabase.watchUserSetting(currentUser.id, SettingKeys.collapseSeries),
      builder: (context, snapshot) {
        final collapseSeriesEnabled = SettingsParser.decodeValue<bool>(snapshot.data?.value, collapseSeriesFallback);
        final initialCollapseSeries = selectedLibrary.mediaType == 'book' && collapseSeriesEnabled ? 1 : 0;
        final itemsProvider = libraryItemsProvider(
          libraryId,
          initialFilter: initialFilter,
          initialCollapseSeries: initialCollapseSeries,
        );
        final libraryItemsStateAsync = ref.watch(itemsProvider);

        return libraryItemsStateAsync.when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (state) {
            final items = state.items;
            final canManageBooks = selectedLibrary.mediaType == 'book';
            final hasUpdatePermission = currentUser?.permissions.update ?? false;
            final hasDeletePermission = currentUser?.permissions.delete ?? false;
            final canEditItems = hasUpdatePermission && managementPreferences.editItemsEnabled;
            final canQuickMatchItems =
                canManageBooks && canEditItems && managementPreferences.allowMatchesQuickMatchesEnabled;
            final editableItemIds = items
                .where((item) => item.collapsedSeries == null)
                .map((item) => item.id)
                .toList(growable: false);

            if (editingItemId.value != null && !editableItemIds.contains(editingItemId.value)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                editingItemId.value = null;
              });
            }

            return LibraryMultiSelectHost(
              scopeKey: 'library:$libraryId:${initialFilter ?? ''}',
              libraryId: libraryId,
              visibleItems: items,
              enableShiftRange: true,
              canAddToPlaylist: canManageBooks && currentUser != null,
              canAddToCollection: canManageBooks && hasUpdatePermission && managementPreferences.collectionsEnabled,
              canQuickMatchItems: canQuickMatchItems,
              canDeleteItems: canManageBooks && hasDeletePermission && managementPreferences.deleteItemsEnabled,
              currentUserId: currentUser?.id,
              onAfterDelete: () => ref.read(itemsProvider.notifier).refresh(),
              builder: (context, selection) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        children: [
                          LibraryFilterToolbar(
                            libraryMediaType: selectedLibrary.mediaType,
                            activeFilter: state.filter,
                            activeSort: state.sort,
                            activeSortDesc: state.desc,
                            filterDataAsync: filterDataAsync,
                            onFilterSelected: (filterQuery) => ref.read(itemsProvider.notifier).setFilter(filterQuery),
                            onSortSelected: (sortSelection) => ref
                                .read(itemsProvider.notifier)
                                .setSort(sortSelection.sort, newDesc: sortSelection.desc),
                            onClearFilter: () => ref.read(itemsProvider.notifier).clearFilter(),
                          ),
                          Expanded(
                            child: items.isEmpty && !state.hasNextPage && !state.isLoadingNextPage
                                ? const Center(child: Text('No items found in this library.'))
                                : LibraryItemsGrid(
                                    scrollController: scrollController,
                                    items: items,
                                    totalItems: state.totalItems,
                                    hasNextPage: state.hasNextPage,
                                    api: api,
                                    onPlayItem: (item, _) {
                                      audioHandler.playLibraryItem(item);
                                    },
                                    onEnsureLoadedForIndex: (index) {
                                      ref.read(itemsProvider.notifier).ensureLoadedForIndex(index);
                                    },
                                    selectionMode: selection.selectionMode,
                                    selectedItemIds: selection.selectedItemIds,
                                    onToggleSelection: (_, index) => selection.toggleSelectionByIndex(index),
                                    onEnterSelectionMode: (_, index) => selection.enterSelectionByIndex(index),
                                    canEditItems: canEditItems,
                                    onEditItem: (item, _) {
                                      if (selection.selectionMode || item.collapsedSeries != null) {
                                        return;
                                      }
                                      editingItemId.value = item.id;
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                    ScrollToTopButton(controller: scrollController),
                    if (editingItemId.value != null && editableItemIds.contains(editingItemId.value))
                      LibraryItemEditOverlay(
                        orderedItemIds: editableItemIds,
                        currentItemId: editingItemId.value!,
                        filterData: filterDataAsync.asData?.value,
                        onSelectItem: (itemId) {
                          editingItemId.value = itemId;
                        },
                        onClose: () {
                          editingItemId.value = null;
                        },
                        onItemSaved: (_, _) async {},
                      ),
                  ],
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) {
            if (!serverReachable) {
              return ConnectionIssueView.offline(
                onRetry: () async {
                  await ref.read(itemsProvider.notifier).refresh();
                },
              );
            }

            return ConnectionIssueView.requestFailed(
              error: err,
              title: 'Error loading library items',
              onRetry: () async {
                await ref.read(itemsProvider.notifier).refresh();
              },
            );
          },
        );
      },
    );
  }
}
