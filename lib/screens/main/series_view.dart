import 'package:material_ui/material_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/cover_loading_placeholder.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/components/common/loading_view.dart';
import 'package:yaabsa/components/app/library/library_filter_sheet.dart';
import 'package:yaabsa/components/app/library/library_filter_toolbar.dart';
import 'package:yaabsa/components/app/library/library_series_sort_sheet.dart';
import 'package:yaabsa/api/library/request/library_series_sort.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/series_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/util/layout_sizes.dart';
import 'package:yaabsa/util/library_view_subtitle_preferences.dart';
import 'package:yaabsa/util/library_view_subtitles.dart';

const int _seriesPrefetchThreshold = 8;
const int _seriesApproxScrollPastCount = 24;

class SeriesView extends HookConsumerWidget {
  const SeriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    final serverReachable = ref.watch(serverStatusProvider).value ?? false;
    final progressMap = ref.watch(mediaProgressProvider).asData?.value ?? {};
    final currentUser = ref.watch(currentUserProvider).value;
    ref.watch(userSettingsWatcherProvider);

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    if (selectedLibrary.mediaType != 'book') {
      return const Center(child: Text('Series are available only for book libraries.'));
    }

    final libraryId = selectedLibrary.id;
    final api = ref.watch(absApiProvider);
    final filterDataAsync = ref.watch(libraryFilterDataProvider(libraryId));
    final subtitlePreferences = currentUser == null
        ? LibraryViewSubtitlePreferencesCodec.defaultsFor(LibraryViewSubtitleView.series)
        : LibraryViewSubtitlePreferencesCodec.decode(
            ref
                .read(settingsManagerProvider.notifier)
                .getUserSetting<String>(
                  currentUser.id,
                  LibraryViewSubtitleView.series.settingKey,
                  defaultValue: LibraryViewSubtitlePreferencesCodec.defaultEncodedFor(LibraryViewSubtitleView.series),
                ),
            LibraryViewSubtitleView.series,
          );
    if (api == null) {
      return ConnectionIssueView.offline();
    }

    final currentSeriesProvider = seriesProvider(libraryId);
    final seriesStateAsync = ref.watch(currentSeriesProvider);

    return seriesStateAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (state) {
        final seriesItems = state.items;
        final subtitleResolver = LibraryViewSubtitleResolver(
          preferences: subtitlePreferences,
          view: LibraryViewSubtitleView.series,
          activeSort: state.sort,
        );

        Future<void> openFilterSheet() async {
          final result = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (context) => LibraryFilterSheet(
              libraryMediaType: selectedLibrary.mediaType,
              activeFilter: state.filter,
              filterData: filterDataAsync.value,
              includeSpecialFilters: false,
            ),
          );

          if (!context.mounted || result == null) {
            return;
          }

          if (result.isEmpty) {
            await ref.read(currentSeriesProvider.notifier).clearFilter();
          } else {
            await ref.read(currentSeriesProvider.notifier).setFilter(result);
          }
        }

        Future<void> openSortSheet() async {
          final result = await showModalBottomSheet<LibrarySeriesSortSelection>(
            context: context,
            showDragHandle: true,
            builder: (context) => LibrarySeriesSortSheet(activeSort: state.sort, activeSortDesc: state.desc),
          );

          if (!context.mounted || result == null) {
            return;
          }

          await ref.read(currentSeriesProvider.notifier).setSort(result.sort, newDesc: result.desc);
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final gridLayout = appCenteredGridLayout(constraints.maxWidth, tileWidth: appGridTileWidth * 1.5);
            final loadedCount = seriesItems.length;
            final estimatedItemCount = _estimatedItemCount(
              loadedCount: loadedCount,
              totalItems: state.totalItems,
              hasNextPage: state.hasNextPage,
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      _SeriesToolbar(
                        filterLabel: LibraryFilterToolbar.resolveActiveFilterLabel(state.filter, filterDataAsync.value),
                        sortLabel: buildLibrarySeriesSortLabel(activeSort: state.sort, activeDesc: state.desc),
                        isFilterLoading: filterDataAsync.isLoading,
                        isBusy: state.isLoadingNextPage,
                        onFilterPressed: openFilterSheet,
                        onSortPressed: openSortSheet,
                      ),
                      Expanded(
                        child: seriesItems.isEmpty && !state.hasNextPage && !state.isLoadingNextPage
                            ? RefreshIndicator(
                                onRefresh: () =>
                                    ref.read(seriesProvider(libraryId).notifier).refresh(withLoading: false),
                                child: ListView(
                                  controller: scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                                  children: const [
                                    SizedBox(height: 80),
                                    Center(child: Text('No series found in this library.')),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () =>
                                    ref.read(seriesProvider(libraryId).notifier).refresh(withLoading: false),
                                child: AlignedGridView.count(
                                  controller: scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(
                                    gridLayout.horizontalPadding,
                                    8,
                                    gridLayout.horizontalPadding,
                                    16,
                                  ),
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
                                    final seriesEntry = MultiBookEntryData(
                                      id: baseEntry.id,
                                      title: baseEntry.title,
                                      subtitle: subtitleResolver.forSeries(series) ?? const LibraryViewSubtitle.empty(),
                                      bookItemIds: baseEntry.bookItemIds,
                                      totalBooks: baseEntry.totalBooks,
                                    );

                                    double totalProgress = 0.0;
                                    int booksWithProgress = 0;
                                    for (final bookId in baseEntry.bookItemIds) {
                                      final p = progressMap[bookId];
                                      if (p != null) {
                                        totalProgress += p.isFinished ? 1.0 : p.progress;
                                        booksWithProgress++;
                                      }
                                    }

                                    double? seriesProgress;
                                    if (booksWithProgress > 0 && baseEntry.totalBookCount > 0) {
                                      seriesProgress = (totalProgress / baseEntry.totalBookCount).clamp(0.0, 1.0);
                                    }

                                    return MultiBookEntryWidget(
                                      api: api,
                                      entry: seriesEntry,
                                      compact: constraints.maxWidth < 700,
                                      squareCover: true,
                                      coverHeight: appGridTileWidth,
                                      showSubtitle: true,
                                      progress: seriesProgress,
                                      maxBooksToShow: defaultMultiBookPreviewLimit,
                                      onTap: () {
                                        context.push('/series/${series.id}', extra: seriesEntry);
                                      },
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                ScrollToTopButton(controller: scrollController),
              ],
            );
          },
        );
      },
      loading: () => const LoadingView(),
      error: (error, stackTrace) {
        if (!serverReachable) {
          return ConnectionIssueView.offline(
            onRetry: () async {
              ref.invalidate(currentSeriesProvider);
              await ref.read(currentSeriesProvider.future);
            },
          );
        }

        return ConnectionIssueView.requestFailed(
          error: error,
          title: 'Error loading series',
          onRetry: () async {
            ref.invalidate(currentSeriesProvider);
            await ref.read(currentSeriesProvider.future);
          },
        );
      },
    );
  }
}

int _estimatedItemCount({required int loadedCount, required int totalItems, required bool hasNextPage}) {
  if (totalItems > loadedCount) return totalItems;
  if (hasNextPage) return loadedCount + _seriesApproxScrollPastCount;
  return loadedCount;
}

class _SeriesToolbar extends StatelessWidget {
  const _SeriesToolbar({
    required this.filterLabel,
    required this.sortLabel,
    required this.isFilterLoading,
    required this.isBusy,
    required this.onFilterPressed,
    required this.onSortPressed,
  });

  final String? filterLabel;
  final String sortLabel;
  final bool isFilterLoading;
  final bool isBusy;
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;

  @override
  Widget build(BuildContext context) {
    final filterButtonLabel = filterLabel == null ? 'Filter' : _truncateLabel(filterLabel!);
    final sortButtonLabel = _truncateLabel(sortLabel);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: isBusy ? null : onFilterPressed,
              icon: isFilterLoading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.filter_alt_rounded),
              label: Text(filterButtonLabel, overflow: TextOverflow.ellipsis),
            ),
            OutlinedButton.icon(
              onPressed: isBusy ? null : onSortPressed,
              icon: const Icon(Icons.sort_rounded),
              label: Text(sortButtonLabel, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  static String _truncateLabel(String label, {int maxLength = 34}) {
    if (label.length <= maxLength) {
      return label;
    }

    return '${label.substring(0, maxLength - 1)}…';
  }
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
          const SizedBox(
            width: double.infinity,
            height: appGridTileWidth,
            child: CoverLoadingPlaceholder(borderRadius: 14),
          ),
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
