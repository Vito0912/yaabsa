import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/series_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/layout_sizes.dart';

const int _seriesPrefetchThreshold = 8;
const int _seriesApproxScrollPastCount = 24;

class SeriesView extends ConsumerWidget {
  const SeriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    if (selectedLibrary.mediaType != 'book') {
      return const Center(child: Text('Series are available only for book libraries.'));
    }

    final libraryId = selectedLibrary.id;
    final api = ref.watch(absApiProvider);
    if (api == null) {
      return const Center(child: Text('No server connection available.'));
    }

    final currentSeriesProvider = seriesProvider(libraryId);
    final seriesStateAsync = ref.watch(currentSeriesProvider);

    return seriesStateAsync.when(
      data: (state) {
        final seriesItems = state.items;

        return LayoutBuilder(
          builder: (context, constraints) {
            final gridLayout = appCenteredGridLayout(constraints.maxWidth, tileWidth: appGridTileWidth * 1.5);
            final loadedCount = seriesItems.length;
            final estimatedItemCount = _estimatedItemCount(
              loadedCount: loadedCount,
              totalItems: state.totalItems,
              hasNextPage: state.hasNextPage,
            );

            if (seriesItems.isEmpty && !state.hasNextPage && !state.isLoadingNextPage) {
              return const Center(child: Text('No series found in this library.'));
            }

            return RefreshIndicator(
              onRefresh: () => ref.read(seriesProvider(libraryId).notifier).refresh(withLoading: false),
              child: AlignedGridView.count(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(gridLayout.horizontalPadding, 12, gridLayout.horizontalPadding, 16),
                crossAxisCount: gridLayout.crossAxisCount,
                mainAxisSpacing: appGridSpacing,
                crossAxisSpacing: appGridSpacing,
                itemCount: estimatedItemCount,
                itemBuilder: (context, index) {
                  if (index >= loadedCount - _seriesPrefetchThreshold) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(currentSeriesProvider.notifier).ensureLoadedForIndex(index);
                    });
                  }

                  if (index >= loadedCount) return const _SeriesGridPlaceholderTile();

                  final series = seriesItems[index];
                  final baseEntry = MultiBookEntryData.fromSeries(series);
                  final sequence = series.sequence?.trim();
                  final subtitle = sequence != null && sequence.isNotEmpty
                      ? baseEntry.totalBookCount > 0
                            ? 'Series #$sequence • ${baseEntry.totalBookCount} books'
                            : 'Series #$sequence'
                      : baseEntry.subtitle;
                  final seriesEntry = MultiBookEntryData(
                    id: baseEntry.id,
                    title: baseEntry.title,
                    subtitle: subtitle,
                    bookItemIds: baseEntry.bookItemIds,
                    totalBooks: baseEntry.totalBooks,
                  );

                  return MultiBookEntryWidget(
                    api: api,
                    entry: seriesEntry,
                    compact: constraints.maxWidth < 700,
                    squareCover: true,
                    coverHeight: appGridTileWidth,
                    showSubtitle: true,
                    maxBooksToShow: defaultMultiBookPreviewLimit,
                    onTap: () {
                      context.push('/series/${series.id}', extra: seriesEntry);
                    },
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error loading series: $error')),
    );
  }
}

int _estimatedItemCount({required int loadedCount, required int totalItems, required bool hasNextPage}) {
  if (totalItems > loadedCount) return totalItems;
  if (hasNextPage) return loadedCount + _seriesApproxScrollPastCount;
  return loadedCount;
}

class _SeriesGridPlaceholderTile extends StatelessWidget {
  const _SeriesGridPlaceholderTile();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: double.infinity, height: appGridTileWidth, child: CoverPlaceholder(borderRadius: 14)),
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
            widthFactor: 0.56,
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
