import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/cover_loading_placeholder.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/util/layout_sizes.dart';

const int _libraryPrefetchThreshold = 8;
const int _libraryApproxScrollPastCount = 24;

class LibraryItemsGrid extends StatelessWidget {
  const LibraryItemsGrid({
    super.key,
    required this.scrollController,
    required this.items,
    required this.totalItems,
    required this.hasNextPage,
    required this.api,
    required this.onEnsureLoadedForIndex,
    this.selectionMode = false,
    this.selectedItemIds = const <String>{},
    this.onToggleSelection,
    this.onEnterSelectionMode,
  });

  final ScrollController scrollController;
  final List<LibraryItem> items;
  final int totalItems;
  final bool hasNextPage;
  final ABSApi api;
  final ValueChanged<int> onEnsureLoadedForIndex;
  final bool selectionMode;
  final Set<String> selectedItemIds;
  final ValueChanged<String>? onToggleSelection;
  final ValueChanged<String>? onEnterSelectionMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final gridLayout = appCenteredGridLayout(constraints.maxWidth);
        final loadedCount = items.length;
        final estimatedItemCount = estimateLibraryItemCount(
          loadedCount: loadedCount,
          totalItems: totalItems,
          hasNextPage: hasNextPage,
        );

        return AlignedGridView.count(
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
                onEnsureLoadedForIndex(index);
              });
            }

            if (index >= loadedCount) {
              return const _LibraryGridPlaceholderTile();
            }

            final item = items[index];

            return LibraryItemWidget(
              item,
              api,
              showProgress: true,
              squareCover: true,
              selectionMode: selectionMode,
              isSelected: selectedItemIds.contains(item.id),
              onToggleSelection: onToggleSelection == null ? null : () => onToggleSelection!(item.id),
              onEnterSelectionMode: onEnterSelectionMode == null ? null : () => onEnterSelectionMode!(item.id),
            );
          },
        );
      },
    );
  }
}

int estimateLibraryItemCount({required int loadedCount, required int totalItems, required bool hasNextPage}) {
  if (totalItems > loadedCount) {
    return totalItems;
  }

  if (hasNextPage) {
    return loadedCount + _libraryApproxScrollPastCount;
  }

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
          const AspectRatio(aspectRatio: 1, child: CoverLoadingPlaceholder(borderRadius: 16)),
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
