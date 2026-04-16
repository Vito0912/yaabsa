import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/series_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/layout_sizes.dart';

const int _seriesBooksPrefetchThreshold = 8;
const int _seriesBooksApproxScrollPastCount = 24;

class SeriesDetailView extends ConsumerWidget {
  const SeriesDetailView({required this.seriesId, super.key, this.initialEntry});

  final String seriesId;
  final MultiBookEntryData? initialEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    if (selectedLibrary.mediaType != 'book') {
      return const Center(child: Text('Series are available only for book libraries.'));
    }

    final api = ref.watch(absApiProvider);
    if (api == null) {
      return const Center(child: Text('No server connection available.'));
    }

    final libraryId = selectedLibrary.id;
    final allSeriesAsync = ref.watch(seriesProvider(libraryId));
    final resolvedEntry = _resolveEntry(seriesId, initialEntry, allSeriesAsync.value?.items);

    if (resolvedEntry == null) {
      if (allSeriesAsync.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return const Center(child: Text('Series details could not be loaded.'));
    }

    final booksArgs = SeriesBooksArgs(libraryId: libraryId, seriesId: seriesId);
    final currentBooksProvider = seriesBooksProvider(booksArgs);
    final booksStateAsync = ref.watch(currentBooksProvider);

    return booksStateAsync.when(
      data: (state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final gridLayout = appCenteredGridLayout(constraints.maxWidth);
            final horizontalPadding = gridLayout.horizontalPadding;
            final loadedCount = state.items.length;
            final estimatedItemCount = _estimatedItemCount(
              loadedCount: loadedCount,
              totalItems: state.totalItems,
              hasNextPage: state.hasNextPage,
            );

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 10, horizontalPadding, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        tooltip: 'Back',
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          resolvedEntry.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                if (resolvedEntry.subtitle != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(horizontalPadding + 58, 0, horizontalPadding, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        resolvedEntry.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                if (state.items.isEmpty && !state.hasNextPage && !state.isLoadingNextPage)
                  const Expanded(child: Center(child: Text('No books found in this series.')))
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => ref.read(seriesBooksProvider(booksArgs).notifier).refresh(withLoading: false),
                      child: AlignedGridView.count(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
                        crossAxisCount: gridLayout.crossAxisCount,
                        mainAxisSpacing: appGridSpacing,
                        crossAxisSpacing: appGridSpacing,
                        itemCount: estimatedItemCount,
                        itemBuilder: (context, index) {
                          if (index >= loadedCount - _seriesBooksPrefetchThreshold) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ref.read(currentBooksProvider.notifier).ensureLoadedForIndex(index);
                            });
                          }

                          if (index >= loadedCount) return const _SeriesBooksPlaceholderTile();

                          return LibraryItemWidget(state.items[index], api, showProgress: true, squareCover: true);
                        },
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error loading series books: $error')),
    );
  }
}

int _estimatedItemCount({required int loadedCount, required int totalItems, required bool hasNextPage}) {
  if (totalItems > loadedCount) return totalItems;
  if (hasNextPage) return loadedCount + _seriesBooksApproxScrollPastCount;
  return loadedCount;
}

class _SeriesBooksPlaceholderTile extends StatelessWidget {
  const _SeriesBooksPlaceholderTile();

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
            widthFactor: 0.6,
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

MultiBookEntryData? _resolveEntry(String seriesId, MultiBookEntryData? initialEntry, List<Series>? allSeries) {
  if (initialEntry != null && initialEntry.id == seriesId) {
    return initialEntry;
  }

  if (allSeries != null) {
    for (final series in allSeries) {
      if (series.id == seriesId) {
        return MultiBookEntryData.fromSeries(series);
      }
    }
  }

  return initialEntry;
}
