import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/layout_sizes.dart';

const int _libraryPrefetchThreshold = 8;
const int _libraryApproxScrollPastCount = 24;

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

    final api = ref.watch(absApiProvider);
    if (api == null) {
      return const Center(child: Text('No server connection available.'));
    }

    return libraryItemsStateAsync.when(
      data: (state) {
        final items = state.items;

        if (items.isEmpty && !state.hasNextPage && !state.isLoadingNextPage) {
          return const Center(child: Text('No items found in this library.'));
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final gridLayout = appCenteredGridLayout(constraints.maxWidth);
            final loadedCount = items.length;
            final estimatedItemCount = _estimatedItemCount(
              loadedCount: loadedCount,
              totalItems: state.totalItems,
              hasNextPage: state.hasNextPage,
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: AlignedGridView.count(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(gridLayout.horizontalPadding, 8, gridLayout.horizontalPadding, 16),
                    crossAxisCount: gridLayout.crossAxisCount,
                    mainAxisSpacing: appGridSpacing,
                    crossAxisSpacing: appGridSpacing,
                    itemCount: estimatedItemCount,
                    itemBuilder: (context, index) {
                      if (index >= loadedCount - _libraryPrefetchThreshold) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ref.read(itemsProvider.notifier).ensureLoadedForIndex(index);
                        });
                      }

                      if (index >= loadedCount) return const _LibraryGridPlaceholderTile();

                      return LibraryItemWidget(items[index], api, showProgress: true, squareCover: true);
                    },
                  ),
                ),
                ScrollToTopButton(controller: scrollController),
              ],
            );
          },
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

int _estimatedItemCount({required int loadedCount, required int totalItems, required bool hasNextPage}) {
  if (totalItems > loadedCount) return totalItems;
  if (hasNextPage) return loadedCount + _libraryApproxScrollPastCount;
  return loadedCount;
}

class _LibraryGridPlaceholderTile extends StatelessWidget {
  const _LibraryGridPlaceholderTile();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AspectRatio(aspectRatio: 1, child: CoverPlaceholder(borderRadius: 16)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 6),
          FractionallySizedBox(
            widthFactor: 0.62,
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
