import 'dart:math' as math;

import 'package:yaabsa/ui/components/inputs/search_field.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/ui/components/inputs/field_decoration.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';
import 'package:yaabsa/util/l10n.dart';

class PodcastEpisodesHeaderCard extends StatelessWidget {
  const PodcastEpisodesHeaderCard({
    super.key,
    required this.totalEpisodeCount,
    required this.visibleEpisodeCount,
    required this.searchQuery,
    required this.searchController,
    required this.progressFilter,
    required this.sortMode,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onFilterChanged,
    required this.onSortChanged,
    this.selectionMode = false,
    this.selectedCount = 0,
    this.onClearSelection,
    this.onSelectAll,
    this.onDownloadSelected,
    this.onAddSelectedToPlaylist,
    this.onToggleSelectedFinished,
    this.allSelectedFinished = false,
  });

  final int totalEpisodeCount;
  final int visibleEpisodeCount;
  final String searchQuery;
  final TextEditingController searchController;
  final PodcastEpisodeProgressFilter progressFilter;
  final PodcastEpisodeSortMode sortMode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<PodcastEpisodeProgressFilter> onFilterChanged;
  final ValueChanged<PodcastEpisodeSortMode> onSortChanged;
  final bool selectionMode;
  final int selectedCount;
  final VoidCallback? onClearSelection;
  final VoidCallback? onSelectAll;
  final VoidCallback? onDownloadSelected;
  final VoidCallback? onAddSelectedToPlaylist;
  final VoidCallback? onToggleSelectedFinished;
  final bool allSelectedFinished;

  @override
  Widget build(BuildContext context) {
    if (selectionMode) {
      return Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: onClearSelection,
                icon: const Icon(Icons.close_rounded),
                tooltip: context.l10n.actionClearSelection,
              ),
              const SizedBox(width: 8),
              Text(context.l10n.selectedCount(selectedCount), style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              if (onSelectAll != null)
                IconButton(
                  onPressed: onSelectAll,
                  icon: const Icon(Icons.select_all_rounded),
                  tooltip: context.l10n.actionSelectAll,
                ),
              if (onDownloadSelected != null)
                IconButton(
                  onPressed: onDownloadSelected,
                  icon: const Icon(Icons.download_rounded),
                  tooltip: context.l10n.actionDownloadSelectedEpisodes,
                ),
              if (onToggleSelectedFinished != null)
                IconButton(
                  onPressed: onToggleSelectedFinished,
                  icon: Icon(allSelectedFinished ? Icons.remove_done_rounded : Icons.task_alt_rounded),
                  tooltip: allSelectedFinished
                      ? context.l10n.actionMarkAsUnfinished
                      : context.l10n.actionMarkAsFinished,
                ),
              if (onAddSelectedToPlaylist != null)
                IconButton(
                  onPressed: onAddSelectedToPlaylist,
                  icon: const Icon(Icons.playlist_add_rounded),
                  tooltip: context.l10n.actionAddToPlaylist,
                ),
            ],
          ),
        ),
      );
    }

    final resultLabel = visibleEpisodeCount == totalEpisodeCount
        ? context.l10n.episodeCount(totalEpisodeCount)
        : context.l10n.statusEpisodeResultsSubset(visibleEpisodeCount, totalEpisodeCount);
    final searchField = YaabsaSearchField(
      controller: searchController,
      onChanged: onSearchChanged,
      isDense: true,
      hintText: context.l10n.hintSearchEpisodes,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      suffixIcon: searchQuery.trim().isEmpty
          ? null
          : IconButton(
              onPressed: onClearSearch,
              icon: const Icon(Icons.close_rounded),
              tooltip: context.l10n.actionClear,
            ),
    );

    final filterButton = YaabsaExpressiveDropdownField<PodcastEpisodeProgressFilter>(
      value: progressFilter,
      options: PodcastEpisodeProgressFilter.values
          .map(
            (value) =>
                YaabsaDropdownOption(value: value, label: podcastEpisodeProgressFilterLabel(value, context.l10n)),
          )
          .toList(growable: false),
      onChanged: (value) {
        if (value != null) {
          onFilterChanged(value);
        }
      },
      decoration: const InputDecoration(
        isDense: true,
        prefixIcon: Icon(Icons.filter_alt_rounded, size: 18),
        constraints: BoxConstraints(minHeight: YaabsaFieldDimensions.compactHeight),
      ),
    );

    final sortButton = YaabsaExpressiveDropdownField<PodcastEpisodeSortMode>(
      value: sortMode,
      options: PodcastEpisodeSortMode.values
          .map((value) => YaabsaDropdownOption(value: value, label: podcastEpisodeSortModeLabel(value, context.l10n)))
          .toList(growable: false),
      onChanged: (value) {
        if (value != null) {
          onSortChanged(value);
        }
      },
      decoration: const InputDecoration(
        isDense: true,
        prefixIcon: Icon(Icons.sort_rounded, size: 18),
        constraints: BoxConstraints(minHeight: YaabsaFieldDimensions.compactHeight),
      ),
    );

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.headingEpisodes, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 2),
            Text(
              resultLabel,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final filterWidth = _widestDropdownFieldWidth(
                  context,
                  PodcastEpisodeProgressFilter.values.map(
                    (value) => podcastEpisodeProgressFilterLabel(value, context.l10n),
                  ),
                );
                final sortWidth = _widestDropdownFieldWidth(
                  context,
                  PodcastEpisodeSortMode.values.map((value) => podcastEpisodeSortModeLabel(value, context.l10n)),
                );
                const fieldSpacing = 8.0;
                const minimumSearchWidth = 200.0;
                final actionsWidth = filterWidth + sortWidth + fieldSpacing;
                final oneRowMinimumWidth = actionsWidth + minimumSearchWidth + fieldSpacing * 2;
                final hasFiniteWidth = constraints.maxWidth.isFinite;
                final availableWidth = constraints.maxWidth;
                final canKeepAllControlsInOneRow = hasFiniteWidth && availableWidth >= oneRowMinimumWidth;

                if (canKeepAllControlsInOneRow) {
                  return Row(
                    children: [
                      Expanded(child: searchField),
                      const SizedBox(width: fieldSpacing),
                      SizedBox(width: filterWidth, child: filterButton),
                      const SizedBox(width: fieldSpacing),
                      SizedBox(width: sortWidth, child: sortButton),
                    ],
                  );
                }

                final compactRow = Row(
                  children: [
                    Expanded(child: filterButton),
                    const SizedBox(width: fieldSpacing),
                    Expanded(child: sortButton),
                  ],
                );

                if (hasFiniteWidth) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      searchField,
                      const SizedBox(height: fieldSpacing),
                      compactRow,
                    ],
                  );
                }

                final unboundedWidth = math.max(
                  minimumSearchWidth + actionsWidth + fieldSpacing * 2,
                  math.max(filterWidth, sortWidth),
                );
                return SizedBox(
                  width: unboundedWidth,
                  child: Row(
                    children: [
                      Expanded(child: searchField),
                      const SizedBox(width: fieldSpacing),
                      SizedBox(width: filterWidth, child: filterButton),
                      const SizedBox(width: fieldSpacing),
                      SizedBox(width: sortWidth, child: sortButton),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

double _widestDropdownFieldWidth(BuildContext context, Iterable<String> labels) {
  final style = Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);
  final textScaler = MediaQuery.textScalerOf(context);
  final textDirection = Directionality.of(context);
  var widestLabel = 0.0;

  for (final label in labels) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: 1,
    )..layout();
    widestLabel = widestLabel < painter.width ? painter.width : widestLabel;
  }

  const fieldChromeWidth = 76.0;
  return widestLabel + fieldChromeWidth;
}
