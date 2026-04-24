import 'package:flutter/material.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';

class PodcastEpisodesHeaderCard extends StatelessWidget {
  const PodcastEpisodesHeaderCard({
    super.key,
    required this.totalEpisodeCount,
    required this.visibleEpisodeCount,
    required this.searchQuery,
    required this.searchController,
    required this.isMobileLayout,
    required this.progressFilter,
    required this.sortMode,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  final int totalEpisodeCount;
  final int visibleEpisodeCount;
  final String searchQuery;
  final TextEditingController searchController;
  final bool isMobileLayout;
  final PodcastEpisodeProgressFilter progressFilter;
  final PodcastEpisodeSortMode sortMode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<PodcastEpisodeProgressFilter> onFilterChanged;
  final ValueChanged<PodcastEpisodeSortMode> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final resultLabel = visibleEpisodeCount == totalEpisodeCount
        ? '$totalEpisodeCount episodes'
        : '$visibleEpisodeCount of $totalEpisodeCount episodes';

    final searchField = TextField(
      controller: searchController,
      onChanged: onSearchChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: const Icon(Icons.search_rounded),
        hintText: 'Search episodes by title',
        suffixIcon: searchQuery.trim().isEmpty
            ? null
            : IconButton(onPressed: onClearSearch, icon: const Icon(Icons.close_rounded), tooltip: 'Clear search'),
        border: const OutlineInputBorder(),
      ),
    );

    final filterButton = PopupMenuButton<PodcastEpisodeProgressFilter>(
      initialValue: progressFilter,
      onSelected: onFilterChanged,
      itemBuilder: (context) {
        return PodcastEpisodeProgressFilter.values
            .map((value) => PopupMenuItem(value: value, child: Text(podcastEpisodeProgressFilterLabel(value))))
            .toList(growable: false);
      },
      child: _PopupActionButton(
        icon: Icons.filter_alt_rounded,
        label: 'Filter: ${podcastEpisodeProgressFilterLabel(progressFilter)}',
      ),
    );

    final sortButton = PopupMenuButton<PodcastEpisodeSortMode>(
      initialValue: sortMode,
      onSelected: onSortChanged,
      itemBuilder: (context) {
        return PodcastEpisodeSortMode.values
            .map((value) => PopupMenuItem(value: value, child: Text(podcastEpisodeSortModeLabel(value))))
            .toList(growable: false);
      },
      child: _PopupActionButton(icon: Icons.sort_rounded, label: 'Sort: ${podcastEpisodeSortModeLabel(sortMode)}'),
    );

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Episodes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 2),
            Text(
              resultLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            if (isMobileLayout)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  searchField,
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: filterButton),
                      const SizedBox(width: 8),
                      Expanded(child: sortButton),
                    ],
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(child: searchField),
                  const SizedBox(width: 8),
                  filterButton,
                  const SizedBox(width: 8),
                  sortButton,
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _PopupActionButton extends StatelessWidget {
  const _PopupActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
        color: colorScheme.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_drop_down_rounded),
        ],
      ),
    );
  }
}
