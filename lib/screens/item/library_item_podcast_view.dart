import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_details.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_tile.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episodes_header_card.dart';
import 'package:yaabsa/screens/item/podcast/podcast_header_card.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/bg_audio_handler.dart';

class LibraryItemPodcastView extends ConsumerStatefulWidget {
  const LibraryItemPodcastView({super.key, required this.item, required this.canDownload});

  final LibraryItem item;
  final bool canDownload;

  @override
  ConsumerState<LibraryItemPodcastView> createState() => _LibraryItemPodcastViewState();
}

class _LibraryItemPodcastViewState extends ConsumerState<LibraryItemPodcastView> {
  PodcastEpisodeProgressFilter _progressFilter = PodcastEpisodeProgressFilter.all;
  PodcastEpisodeSortMode _sortMode = PodcastEpisodeSortMode.newestFirst;
  bool _showFullDescription = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(absApiProvider);
    if (api == null) {
      return const Center(child: Text('No server connection available.'));
    }

    final podcastMedia = widget.item.media?.podcastMedia;
    if (podcastMedia == null) {
      return const Center(child: Text('Podcast metadata is unavailable.'));
    }

    final allEpisodes = podcastMedia.episodes ?? const <Episode>[];
    final progressMap = ref.watch(mediaProgressProvider).asData?.value ?? const <String, MediaProgress>{};
    final visibleEpisodes = _buildVisibleEpisodes(allEpisodes, progressMap);
    final firstPlayableEpisode = visibleEpisodes.where((episode) => episode.audioFile != null).firstOrNull;

    final horizontalPadding = context.isMobile
        ? 8.0
        : context.isTablet
        ? 16.0
        : 24.0;
    final maxWidth = context.isDesktop
        ? 1120.0
        : context.isTablet
        ? 940.0
        : double.infinity;

    final totalDurationSeconds = widget.item.media?.duration() ?? 0;
    final totalDuration = totalDurationSeconds <= 0 ? null : Duration(seconds: totalDurationSeconds.round());

    return StreamBuilder<PlayerQueueSnapshot>(
      stream: audioHandler.queueSnapshotStream,
      initialData: audioHandler.queueSnapshot,
      builder: (context, queueSnapshotBuilder) {
        final queueSnapshot = queueSnapshotBuilder.data ?? const PlayerQueueSnapshot();

        return StreamBuilder<PlayerState>(
          stream: audioHandler.player.playerStateStream,
          initialData: audioHandler.player.playerState,
          builder: (context, playerStateBuilder) {
            final playerState = playerStateBuilder.data;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 10),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: PodcastHeaderCard(
                          item: widget.item,
                          cover: api.getLibraryItemApi().getLibraryItemCover(widget.item.id, item: widget.item),
                          totalEpisodes: allEpisodes.length,
                          visibleEpisodes: visibleEpisodes.length,
                          duration: totalDuration,
                          showFullDescription: _showFullDescription,
                          onBack: () => context.pop(),
                          onPlayLatest: firstPlayableEpisode == null
                              ? null
                              : () => _playEpisode(firstPlayableEpisode, visibleEpisodes),
                          onToggleDescription: () {
                            setState(() {
                              _showFullDescription = !_showFullDescription;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxWidth),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  PodcastEpisodesHeaderCard(
                                    totalEpisodeCount: allEpisodes.length,
                                    visibleEpisodeCount: visibleEpisodes.length,
                                    searchQuery: _searchQuery,
                                    searchController: _searchController,
                                    isMobileLayout: context.isMobile,
                                    progressFilter: _progressFilter,
                                    sortMode: _sortMode,
                                    onSearchChanged: (value) {
                                      setState(() {
                                        _searchQuery = value;
                                      });
                                    },
                                    onClearSearch: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                    onFilterChanged: (filter) {
                                      setState(() {
                                        _progressFilter = filter;
                                      });
                                    },
                                    onSortChanged: (sortMode) {
                                      setState(() {
                                        _sortMode = sortMode;
                                      });
                                    },
                                  ),
                                  const Divider(height: 1),
                                  if (visibleEpisodes.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.all(24),
                                      child: Center(
                                        child: Text('No episodes match the current search/filter settings.'),
                                      ),
                                    )
                                  else
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: visibleEpisodes.length,
                                      separatorBuilder: (_, _) => const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final episode = visibleEpisodes[index];
                                        final episodeProgress =
                                            progressMap[mediaProgressKey(widget.item.id, episode.id)];
                                        final isQueued = queueSnapshot.entries.any(
                                          (entry) =>
                                              entry.item.itemId == widget.item.id && entry.item.episodeId == episode.id,
                                        );

                                        final isCurrentEpisode =
                                            audioHandler.currentMediaItem?.itemId == widget.item.id &&
                                            audioHandler.currentMediaItem?.episodeId == episode.id;
                                        final isPlayingCurrentEpisode =
                                            isCurrentEpisode && (playerState?.playing ?? false);

                                        return PodcastEpisodeTile(
                                          episode: episode,
                                          progress: episodeProgress,
                                          canDownload: widget.canDownload,
                                          isQueued: isQueued,
                                          isCurrentEpisode: isCurrentEpisode,
                                          isPlayingCurrentEpisode: isPlayingCurrentEpisode,
                                          onOpenDetails: () => _openEpisodeDetails(episode, visibleEpisodes),
                                          onPlayPressed: episode.audioFile == null
                                              ? null
                                              : () {
                                                  if (isCurrentEpisode) {
                                                    if (isPlayingCurrentEpisode) {
                                                      audioHandler.pause();
                                                    } else {
                                                      audioHandler.play();
                                                    }
                                                    return;
                                                  }

                                                  _playEpisode(episode, visibleEpisodes);
                                                },
                                          onQueueToggle: () {
                                            if (isQueued) {
                                              audioHandler.removeFromQueueByItemId(
                                                widget.item.id,
                                                episodeId: episode.id,
                                              );
                                              return;
                                            }

                                            audioHandler.addPodcastEpisodeToQueue(widget.item, episode);
                                          },
                                          onDownloadPressed: widget.canDownload
                                              ? () {
                                                  downloadHandler.downloadFile(widget.item.id, episodeId: episode.id);
                                                }
                                              : null,
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _openEpisodeDetails(Episode episode, List<Episode> orderedEpisodes) async {
    if (context.isMobile) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PodcastEpisodeDetailsPage(
            item: widget.item,
            episode: episode,
            canDownload: widget.canDownload,
            onPlayEpisode: () => _playEpisode(episode, orderedEpisodes),
          ),
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760, maxHeight: 760),
            child: PodcastEpisodeDetailsContent(
              item: widget.item,
              episode: episode,
              canDownload: widget.canDownload,
              onPlayEpisode: () => _playEpisode(episode, orderedEpisodes),
              showCloseButton: true,
            ),
          ),
        );
      },
    );
  }

  void _playEpisode(Episode episode, List<Episode> orderedEpisodes) {
    final episodeIndex = orderedEpisodes.indexWhere((candidate) => candidate.id == episode.id);
    audioHandler.playPodcastEpisode(
      widget.item,
      episode,
      episodeIndex: episodeIndex >= 0 ? episodeIndex : null,
      orderedEpisodes: orderedEpisodes,
    );
  }

  List<Episode> _buildVisibleEpisodes(List<Episode> episodes, Map<String, MediaProgress> progressMap) {
    final normalizedQuery = _searchQuery.trim().toLowerCase();

    final filtered = episodes
        .where((episode) {
          if (episode.audioFile == null) {
            return false;
          }

          final progress = progressMap[mediaProgressKey(widget.item.id, episode.id)];
          if (!_matchesFilter(progress)) {
            return false;
          }

          if (normalizedQuery.isEmpty) {
            return true;
          }

          final title = podcastEpisodeTitle(episode).toLowerCase();
          return title.contains(normalizedQuery);
        })
        .toList(growable: true);

    filtered.sort((left, right) => _compareEpisodes(left, right));
    return filtered;
  }

  bool _matchesFilter(MediaProgress? progress) {
    switch (_progressFilter) {
      case PodcastEpisodeProgressFilter.all:
        return true;
      case PodcastEpisodeProgressFilter.incomplete:
        return !podcastEpisodeInProgress(progress) && !podcastEpisodeCompleted(progress);
      case PodcastEpisodeProgressFilter.inProgress:
        return podcastEpisodeInProgress(progress);
      case PodcastEpisodeProgressFilter.complete:
        return podcastEpisodeCompleted(progress);
    }
  }

  int _compareEpisodes(Episode left, Episode right) {
    switch (_sortMode) {
      case PodcastEpisodeSortMode.newestFirst:
        return _episodeTimestamp(right).compareTo(_episodeTimestamp(left));
      case PodcastEpisodeSortMode.oldestFirst:
        return _episodeTimestamp(left).compareTo(_episodeTimestamp(right));
      case PodcastEpisodeSortMode.titleAsc:
        return podcastEpisodeTitle(left).toLowerCase().compareTo(podcastEpisodeTitle(right).toLowerCase());
      case PodcastEpisodeSortMode.titleDesc:
        return podcastEpisodeTitle(right).toLowerCase().compareTo(podcastEpisodeTitle(left).toLowerCase());
    }
  }

  int _episodeTimestamp(Episode episode) {
    return episode.publishedAt ?? episode.addedAt ?? 0;
  }
}
