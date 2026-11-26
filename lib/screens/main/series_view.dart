import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/components/common/screen_refresh_indicator.dart';
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
import 'package:yaabsa/components/app/series/series_rename_dialog.dart';
import 'package:yaabsa/api/library/request/library_series_sort.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/series_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/ui/components/buttons/sort_button.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/util/layout_sizes.dart';
import 'package:yaabsa/util/library_view_subtitle_preferences.dart';
import 'package:yaabsa/util/library_view_subtitles.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

const int _seriesPrefetchThreshold = 8;
const int _seriesApproxScrollPastCount = 24;

class SeriesView extends HookConsumerWidget {
  const SeriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    final serverReachable = ref.watch(serverStatusProvider).value ?? false;
    final currentUser = ref.watch(currentUserProvider).value;
    ref.watch(userSettingsWatcherProvider);
    final renameSeriesEnabled = watchSettingDefinition(ref, AppSettingDefs.toolsRenameSeries, userId: currentUser?.id);
    final canRenameSeries = renameSeriesEnabled && (currentUser?.permissions.update ?? false);

    if (selectedLibrary == null) {
      return Center(child: Text(context.l10n.errorNoLibrarySelected));
    }

    if (selectedLibrary.mediaType != 'book') {
      return Center(child: Text(context.l10n.errorBookLibrariesOnly));
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
                        filterLabel: LibraryFilterToolbar.resolveActiveFilterLabel(
                          context.l10n,
                          state.filter,
                          filterDataAsync.value,
                        ),
                        sortLabel: buildLibrarySeriesSortLabel(activeSort: state.sort, activeDesc: state.desc),
                        isFilterLoading: filterDataAsync.isLoading,
                        isBusy: state.isLoadingNextPage,
                        onFilterPressed: openFilterSheet,
                        onSortPressed: openSortSheet,
                      ),
                      Expanded(
                        child: seriesItems.isEmpty && !state.hasNextPage && !state.isLoadingNextPage
                            ? ScreenRefreshIndicator(
                                onRefresh: () =>
                                    ref.read(seriesProvider(libraryId).notifier).refresh(withLoading: false),
                                child: ListView(
                                  controller: scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                                  children: [
                                    const SizedBox(height: 80),
                                    Center(child: Text(context.l10n.statusNoSeriesInLibrary)),
                                  ],
                                ),
                              )
                            : ScreenRefreshIndicator(
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

                                    return _SeriesProgressEntry(
                                      api: api,
                                      entry: seriesEntry,
                                      compact: constraints.maxWidth < 700,
                                      onTap: () {
                                        context.push('/series/${series.id}', extra: seriesEntry);
                                      },
                                      onLongPress: canRenameSeries
                                          ? () => _showSeriesActionsSheet(
                                              context: context,
                                              ref: ref,
                                              libraryId: libraryId,
                                              seriesId: series.id,
                                              currentName: series.name,
                                            )
                                          : null,
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
          title: context.l10n.errorLoadingNamedContent(context.l10n.navSeries),
          onRetry: () async {
            ref.invalidate(currentSeriesProvider);
            await ref.read(currentSeriesProvider.future);
          },
        );
      },
    );
  }
}

class _SeriesProgressEntry extends ConsumerWidget {
  const _SeriesProgressEntry({
    required this.api,
    required this.entry,
    required this.compact,
    required this.onTap,
    this.onLongPress,
  });

  final ABSApi api;
  final MultiBookEntryData entry;
  final bool compact;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var totalProgress = 0.0;
    var booksWithProgress = 0;
    for (final bookId in entry.bookItemIds) {
      final bookProgress = ref.watch(mediaProgressByKeyProvider(bookId));
      if (bookProgress != null) {
        totalProgress += bookProgress.isFinished ? 1.0 : bookProgress.progress;
        booksWithProgress++;
      }
    }
    final seriesProgress = booksWithProgress == 0 || entry.totalBookCount <= 0
        ? null
        : (totalProgress / entry.totalBookCount).clamp(0.0, 1.0);

    return MultiBookEntryWidget(
      api: api,
      entry: entry,
      compact: compact,
      squareCover: true,
      coverHeight: appGridTileWidth,
      showSubtitle: true,
      progress: seriesProgress,
      maxBooksToShow: defaultMultiBookPreviewLimit,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

Future<void> _showSeriesActionsSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required String seriesId,
  required String currentName,
}) async {
  final renameSelected = await showModalBottomSheet<bool>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(currentName, maxLines: 1, overflow: TextOverflow.ellipsis)),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(context.l10n.actionRenameSeries),
              onTap: () => Navigator.of(sheetContext).pop(true),
            ),
          ],
        ),
      );
    },
  );

  if (renameSelected != true || !context.mounted) {
    return;
  }

  await showRenameSeriesDialog(context, ref, libraryId: libraryId, seriesId: seriesId, currentName: currentName);
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
    final filterButtonLabel = filterLabel == null ? context.l10n.actionFilter : _truncateLabel(filterLabel!);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: [
            YaabsaButton.small(
              onPressed: isBusy ? null : onFilterPressed,
              variant: YaabsaButtonVariant.outlined,
              icon: isFilterLoading
                  ? const SizedBox(width: 16, height: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.filter_alt_rounded),
              label: Text(filterButtonLabel, overflow: TextOverflow.ellipsis),
            ),
            YaabsaSortButton(
              label: sortLabel,
              tooltip: context.l10n.actionSortBy(sortLabel),
              onPressed: onSortPressed,
              iconOnly: context.isMobile,
              isLoading: isBusy,
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
