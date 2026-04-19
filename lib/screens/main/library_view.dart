import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/app/library/library_filter_toolbar.dart';
import 'package:yaabsa/components/app/library/library_items_grid.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

class LibraryView extends HookConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }
    final String libraryId = selectedLibrary.id;
    final itemsProvider = libraryItemsProvider(libraryId, initialCollapseSeries: 0);
    final libraryItemsStateAsync = ref.watch(itemsProvider);
    final filterDataAsync = ref.watch(libraryFilterDataProvider(libraryId));

    final api = ref.watch(absApiProvider);
    if (api == null) {
      return const Center(child: Text('No server connection available.'));
    }

    return libraryItemsStateAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (state) {
        final items = state.items;

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
                    onSortSelected: (sortSelection) =>
                        ref.read(itemsProvider.notifier).setSort(sortSelection.sort, newDesc: sortSelection.desc),
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
                            onEnsureLoadedForIndex: (index) {
                              ref.read(itemsProvider.notifier).ensureLoadedForIndex(index);
                            },
                          ),
                  ),
                ],
              ),
            ),
            ScrollToTopButton(controller: scrollController),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error loading items: $err', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
