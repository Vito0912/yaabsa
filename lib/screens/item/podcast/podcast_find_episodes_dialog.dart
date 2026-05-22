import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/podcast/podcast_feed.dart';
import 'package:yaabsa/util/item_formatters.dart';

Future<List<PodcastFeedEpisode>?> showPodcastFindEpisodesDialog({
  required BuildContext context,
  required String podcastTitle,
  required List<PodcastFeedEpisode> episodes,
  required List<Episode> existingEpisodes,
}) {
  return showDialog<List<PodcastFeedEpisode>>(
    context: context,
    builder: (_) =>
        _PodcastFindEpisodesDialog(podcastTitle: podcastTitle, episodes: episodes, existingEpisodes: existingEpisodes),
  );
}

class _PodcastFindEpisodesDialog extends StatefulWidget {
  const _PodcastFindEpisodesDialog({
    required this.podcastTitle,
    required this.episodes,
    required this.existingEpisodes,
  });

  final String podcastTitle;
  final List<PodcastFeedEpisode> episodes;
  final List<Episode> existingEpisodes;

  @override
  State<_PodcastFindEpisodesDialog> createState() => _PodcastFindEpisodesDialogState();
}

class _PodcastFindEpisodesDialogState extends State<_PodcastFindEpisodesDialog> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedKeys = <String>{};
  late final List<_EpisodeOption> _episodeOptions;

  String _searchQuery = '';
  bool _sortDescending = true;

  @override
  void initState() {
    super.initState();
    _episodeOptions = _buildEpisodeOptions(widget.episodes, widget.existingEpisodes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_EpisodeOption> get _visibleOptions {
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    final filtered = _episodeOptions
        .where((option) {
          if (normalizedQuery.isEmpty) {
            return true;
          }

          final title = (option.episode.title ?? '').toLowerCase();
          final subtitle = (option.episode.subtitle ?? '').toLowerCase();
          return title.contains(normalizedQuery) || subtitle.contains(normalizedQuery);
        })
        .toList(growable: true);

    filtered.sort((left, right) {
      final leftTime = left.episode.publishedAt ?? 0;
      final rightTime = right.episode.publishedAt ?? 0;
      return _sortDescending ? rightTime.compareTo(leftTime) : leftTime.compareTo(rightTime);
    });

    return filtered;
  }

  List<_EpisodeOption> get _selectableVisibleOptions {
    return _visibleOptions.where((option) => !option.isAlreadyDownloaded).toList(growable: false);
  }

  int get _selectedCount {
    var count = 0;
    for (final option in _episodeOptions) {
      if (!option.isAlreadyDownloaded && _selectedKeys.contains(option.selectionKey)) {
        count++;
      }
    }
    return count;
  }

  bool get _allVisibleSelected {
    final selectable = _selectableVisibleOptions;
    if (selectable.isEmpty) {
      return false;
    }

    for (final option in selectable) {
      if (!_selectedKeys.contains(option.selectionKey)) {
        return false;
      }
    }
    return true;
  }

  String get _downloadButtonLabel {
    if (_selectedCount == 1) {
      return 'Download episode';
    }
    return 'Download $_selectedCount episodes';
  }

  @override
  Widget build(BuildContext context) {
    final visibleOptions = _visibleOptions;
    final selectableVisibleOptions = _selectableVisibleOptions;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960, maxHeight: 760),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.podcastTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(Icons.search_rounded),
                        hintText: 'Search episodes',
                        suffixIcon: _searchQuery.trim().isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Clear search',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: _sortDescending ? 'Sort newest first' : 'Sort oldest first',
                    onPressed: () {
                      setState(() {
                        _sortDescending = !_sortDescending;
                      });
                    },
                    icon: Icon(_sortDescending ? Icons.expand_more_rounded : Icons.expand_less_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (selectableVisibleOptions.isNotEmpty)
                Row(
                  children: [
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _toggleSelectAllVisible,
                      icon: Icon(_allVisibleSelected ? Icons.deselect_rounded : Icons.select_all_rounded),
                      label: Text(_allVisibleSelected ? 'Clear all' : 'Select all'),
                    ),
                  ],
                ),
              const Divider(height: 1),
              Expanded(child: _buildEpisodeList(visibleOptions)),
              const Divider(height: 1),
              const SizedBox(height: 10),
              if (_selectedCount == 0 && _episodeOptions.every((option) => option.isAlreadyDownloaded))
                Text(
                  'All episodes are already downloaded.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                )
              else
                Text(
                  '$_selectedCount selected',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: _selectedCount == 0 ? null : _submit, child: Text(_downloadButtonLabel)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodeList(List<_EpisodeOption> options) {
    if (options.isEmpty) {
      return const Center(child: Text('No feed episodes match your search.'));
    }

    return ListView.separated(
      itemCount: options.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final option = options[index];
        final episode = option.episode;
        final isSelected = _selectedKeys.contains(option.selectionKey);
        final title = (episode.title ?? '').trim().isEmpty ? 'Untitled episode' : episode.title!.trim();
        final subtitle = (episode.subtitle ?? '').trim();
        final dateLabel = _formatPublishedAt(episode.publishedAt);
        final durationLabel = episode.durationSeconds == null || episode.durationSeconds! <= 0
            ? null
            : formatDurationShort(Duration(seconds: episode.durationSeconds!));
        final sizeBytes = episode.enclosure?.length;
        final sizeLabel = sizeBytes == null || sizeBytes <= 0 ? null : formatBytes(sizeBytes);

        final detailParts = <String>[];
        if (dateLabel != null) {
          detailParts.add(dateLabel);
        }
        if (durationLabel != null) {
          detailParts.add('Duration: $durationLabel');
        }
        if (sizeLabel != null) {
          detailParts.add('Size: $sizeLabel');
        }

        return InkWell(
          onTap: option.isAlreadyDownloaded ? null : () => _toggleSelection(option),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (option.isAlreadyDownloaded)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(Icons.download_done_rounded, size: 20, color: Theme.of(context).colorScheme.primary),
                  )
                else
                  SizedBox(
                    width: 26,
                    height: 26,
                    child: Checkbox(value: isSelected, onChanged: (_) => _toggleSelection(option)),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      if (subtitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ),
                      if (detailParts.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            detailParts.join(' • '),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleSelection(_EpisodeOption option) {
    if (option.isAlreadyDownloaded) {
      return;
    }

    setState(() {
      if (_selectedKeys.contains(option.selectionKey)) {
        _selectedKeys.remove(option.selectionKey);
      } else {
        _selectedKeys.add(option.selectionKey);
      }
    });
  }

  void _toggleSelectAllVisible() {
    final selectable = _selectableVisibleOptions;
    if (selectable.isEmpty) {
      return;
    }

    setState(() {
      if (_allVisibleSelected) {
        for (final option in selectable) {
          _selectedKeys.remove(option.selectionKey);
        }
      } else {
        for (final option in selectable) {
          _selectedKeys.add(option.selectionKey);
        }
      }
    });
  }

  void _submit() {
    final selectedEpisodes = _episodeOptions
        .where((option) => !option.isAlreadyDownloaded && _selectedKeys.contains(option.selectionKey))
        .map((option) => option.episode)
        .toList(growable: false);

    Navigator.of(context).pop(selectedEpisodes);
  }
}

class _EpisodeOption {
  const _EpisodeOption({required this.selectionKey, required this.episode, required this.isAlreadyDownloaded});

  final String selectionKey;
  final PodcastFeedEpisode episode;
  final bool isAlreadyDownloaded;
}

List<_EpisodeOption> _buildEpisodeOptions(List<PodcastFeedEpisode> episodes, List<Episode> existingEpisodes) {
  final existingGuids = <String>{};
  final existingUrls = <String>{};
  final existingTitleAndPublished = <String>{};

  for (final episode in existingEpisodes) {
    final guid = episode.guid?.trim();
    if (guid != null && guid.isNotEmpty) {
      existingGuids.add(guid);
    }

    final enclosureUrl = episode.enclosure?.url;
    if (enclosureUrl != null && enclosureUrl.trim().isNotEmpty) {
      existingUrls.add(_cleanEpisodeUrl(enclosureUrl));
    }

    final title = (episode.title ?? '').trim().toLowerCase();
    final publishedAt = episode.publishedAt;
    if (title.isNotEmpty && publishedAt != null) {
      existingTitleAndPublished.add('$title|$publishedAt');
    }
  }

  return episodes
      .asMap()
      .entries
      .map((entry) {
        final index = entry.key;
        final episode = entry.value;
        final selectionKey = _buildSelectionKey(episode, index);
        final guid = episode.guid?.trim();
        final enclosureUrl = episode.enclosure?.url;
        final title = (episode.title ?? '').trim().toLowerCase();
        final titlePublished = title.isNotEmpty && episode.publishedAt != null ? '$title|${episode.publishedAt}' : null;

        final alreadyDownloadedByGuid = guid != null && guid.isNotEmpty && existingGuids.contains(guid);
        final alreadyDownloadedByUrl =
            enclosureUrl != null &&
            enclosureUrl.trim().isNotEmpty &&
            existingUrls.contains(_cleanEpisodeUrl(enclosureUrl));
        final alreadyDownloadedByTitleAndPublished =
            titlePublished != null && existingTitleAndPublished.contains(titlePublished);

        return _EpisodeOption(
          selectionKey: selectionKey,
          episode: episode,
          isAlreadyDownloaded:
              alreadyDownloadedByGuid || alreadyDownloadedByUrl || alreadyDownloadedByTitleAndPublished,
        );
      })
      .toList(growable: false);
}

String _buildSelectionKey(PodcastFeedEpisode episode, int fallbackIndex) {
  final guid = episode.guid?.trim();
  if (guid != null && guid.isNotEmpty) {
    return 'guid:$guid';
  }

  final enclosureUrl = episode.enclosure?.url;
  if (enclosureUrl != null && enclosureUrl.trim().isNotEmpty) {
    return 'url:${_cleanEpisodeUrl(enclosureUrl)}';
  }

  final title = (episode.title ?? '').trim().toLowerCase();
  final publishedAt = episode.publishedAt;
  if (title.isNotEmpty && publishedAt != null) {
    return 'title:$title|$publishedAt';
  }

  return 'index:$fallbackIndex';
}

String _cleanEpisodeUrl(String rawUrl) {
  final uri = Uri.tryParse(rawUrl);
  if (uri == null || uri.queryParameters.isEmpty) {
    return rawUrl;
  }

  final idValue = uri.queryParameters['id'];
  if (idValue == null || idValue.trim().isEmpty) {
    return uri.replace(query: '').toString();
  }

  return uri.replace(queryParameters: <String, String>{'id': idValue}).toString();
}

String? _formatPublishedAt(int? timestampMillis) {
  if (timestampMillis == null || timestampMillis <= 0) {
    return null;
  }

  final date = DateTime.fromMillisecondsSinceEpoch(timestampMillis);
  const months = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  final month = months[date.month - 1];
  return 'Published $month ${date.day}, ${date.year}';
}
