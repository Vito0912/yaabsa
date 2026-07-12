import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/podcast/podcast_feed.dart';
import 'package:yaabsa/components/app/item/editor/open_library_item_editor_dialog.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/components/app/item/item_progress_actions.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/loading_snackbar.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/item/podcast/podcast_find_episodes_dialog.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_details.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_tile.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episodes_header_card.dart';
import 'package:yaabsa/screens/item/podcast/podcast_header_card.dart';
import 'package:yaabsa/screens/player/play_history_view.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/server_management_preferences.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/logger.dart';

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
  bool _isFetchingPodcastFeed = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _selectionMode = false;
  final Set<String> _selectedEpisodeIds = <String>{};

  @override
  void initState() {
    super.initState();

    final currentUserId = ref.read(currentUserProvider).value?.id;
    final settingsManager = ref.read(settingsManagerProvider.notifier);
    final savedFilterValue = settingsManager.getUserSetting<String>(
      currentUserId,
      SettingKeys.podcastEpisodeProgressFilter,
      defaultValue: PodcastEpisodeProgressFilter.all.name,
    );
    _progressFilter = _progressFilterFromSettingValue(savedFilterValue);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(absApiProvider);
    if (api == null) {
      return ConnectionIssueView.offline();
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

    final currentUser = ref.watch(currentUserProvider).value;
    ref.watch(userSettingsWatcherProvider);
    final managementPreferences = readServerManagementPreferences(ref, currentUser?.id);
    final canEditItems = (currentUser?.permissions.update ?? false) && managementPreferences.editItemsEnabled;
    final LibraryFilterData? filterData = widget.item.libraryId == null
        ? null
        : ref.watch(libraryFilterDataProvider(widget.item.libraryId!)).value;
    final appDatabase = ref.watch(appDatabaseProvider);
    final storedDownloadsStream = currentUser == null
        ? Stream<List<InternalDownload>>.value(const <InternalDownload>[])
        : appDatabase.watchStoredDownloadsByUser(currentUser.id);

    return StreamBuilder<List<TaskRecord>>(
      stream: downloadHandler.taskQueueStream,
      initialData: const <TaskRecord>[],
      builder: (context, taskSnapshot) {
        final activeTasks = taskSnapshot.data ?? const <TaskRecord>[];

        return StreamBuilder<List<InternalDownload>>(
          stream: storedDownloadsStream,
          initialData: const <InternalDownload>[],
          builder: (context, storedSnapshot) {
            final storedDownloads = storedSnapshot.data ?? const <InternalDownload>[];

            return StreamBuilder<PlayerQueueSnapshot>(
              stream: audioHandler.queueSnapshotStream,
              initialData: audioHandler.queueSnapshot,
              builder: (context, queueSnapshotBuilder) {
                final queueSnapshot = queueSnapshotBuilder.data ?? const PlayerQueueSnapshot();

                return StreamBuilder<PlayerState>(
                  stream: audioHandler.playerControlStateStream,
                  initialData: audioHandler.playerControlState,
                  builder: (context, playerStateBuilder) {
                    final playerState = playerStateBuilder.data;
                    final latestEpisodeId = firstPlayableEpisode?.id;
                    final isCurrentLatestEpisode =
                        latestEpisodeId != null &&
                        audioHandler.currentMediaItem?.itemId == widget.item.id &&
                        audioHandler.currentMediaItem?.episodeId == latestEpisodeId;
                    final isPlayingCurrentLatestEpisode = isCurrentLatestEpisode && (playerState?.playing ?? false);

                    return StreamBuilder<bool>(
                      stream: audioHandler.queueTransitionLoadingStream,
                      initialData: audioHandler.queueTransitionLoading,
                      builder: (context, queueTransitionSnapshot) {
                        final isQueueTransitionLoading =
                            queueTransitionSnapshot.data ?? audioHandler.queueTransitionLoading;
                        final isLoadingCurrentLatestEpisode =
                            latestEpisodeId != null &&
                            isQueueTransitionLoading &&
                            audioHandler.isQueueTransitionForItem(widget.item.id, episodeId: latestEpisodeId);

                        final notStartedEpisodes = <Episode>[];
                        final unfinishedEpisodes = <Episode>[];

                        for (final episode in visibleEpisodes) {
                          final isDownloaded = storedDownloads.any((d) => d.episode?.id == episode.id && d.isComplete);
                          final isDownloading = activeTasks.any(
                            (task) => downloadHandler.taskBelongsToItem(task, widget.item.id, episodeId: episode.id),
                          );

                          if (!isDownloaded && !isDownloading) {
                            final progress = progressMap[mediaProgressKey(widget.item.id, episode.id)];
                            final isFinished = progress != null && progress.isFinished;

                            if (!isFinished) {
                              unfinishedEpisodes.add(episode);
                              final isNotStarted = progress == null || progress.progress == 0;
                              if (isNotStarted) {
                                notStartedEpisodes.add(episode);
                              }
                            }
                          }
                        }

                        final activePodcastTasks = activeTasks
                            .where((task) => downloadHandler.taskBelongsToItem(task, widget.item.id))
                            .toList();

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
                                      cover: api.getLibraryItemApi().getLibraryItemCover(
                                        widget.item.id,
                                        item: widget.item,
                                      ),
                                      totalEpisodes: allEpisodes.length,
                                      visibleEpisodes: visibleEpisodes.length,
                                      duration: totalDuration,
                                      showFullDescription: _showFullDescription,
                                      isCurrentPlayableEpisode: isCurrentLatestEpisode,
                                      isPlayingCurrentPlayableEpisode: isPlayingCurrentLatestEpisode,
                                      isLoadingCurrentPlayableEpisode: isLoadingCurrentLatestEpisode,
                                      isFindingEpisodes: _isFetchingPodcastFeed,
                                      onBack: () => context.pop(),
                                      onPlayLatest: firstPlayableEpisode == null
                                          ? null
                                          : () {
                                              final episodeToPlay = firstPlayableEpisode;

                                              if (isCurrentLatestEpisode) {
                                                audioHandler.play();
                                                return;
                                              }

                                              _playEpisode(episodeToPlay, visibleEpisodes);
                                            },
                                      onPauseLatest: isCurrentLatestEpisode
                                          ? () {
                                              audioHandler.pause();
                                            }
                                          : null,
                                      onFindEpisodes: canEditItems ? _findEpisodes : null,
                                      onEditPodcast: canEditItems
                                          ? () => openSingleLibraryItemEditorDialog(
                                              context: context,
                                              item: widget.item,
                                              filterData: filterData,
                                            )
                                          : null,
                                      onDownloadPress: widget.canDownload
                                          ? () => _showDownloadOptionsDialog(
                                              notStartedEpisodes: notStartedEpisodes,
                                              unfinishedEpisodes: unfinishedEpisodes,
                                              activePodcastTasks: activePodcastTasks,
                                            )
                                          : null,
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

                                                  final currentUserId = ref.read(currentUserProvider).value?.id;
                                                  unawaited(
                                                    ref
                                                        .read(settingsManagerProvider.notifier)
                                                        .setUserSetting<String>(
                                                          currentUserId,
                                                          SettingKeys.podcastEpisodeProgressFilter,
                                                          filter.name,
                                                        ),
                                                  );
                                                },
                                                onSortChanged: (sortMode) {
                                                  setState(() {
                                                    _sortMode = sortMode;
                                                  });
                                                },
                                                selectionMode: _selectionMode,
                                                selectedCount: _selectedEpisodeIds.length,
                                                onClearSelection: () {
                                                  setState(() {
                                                    _selectionMode = false;
                                                    _selectedEpisodeIds.clear();
                                                  });
                                                },
                                                onSelectAll: () {
                                                  setState(() {
                                                    _selectedEpisodeIds.addAll(visibleEpisodes.map((e) => e.id));
                                                  });
                                                },
                                                onDownloadSelected: () {
                                                  _downloadSelectedEpisodes(
                                                    visibleEpisodes,
                                                    storedDownloads,
                                                    activeTasks,
                                                  );
                                                },
                                              ),
                                              const Divider(height: 1),
                                              if (visibleEpisodes.isEmpty)
                                                const Padding(
                                                  padding: EdgeInsets.all(24),
                                                  child: Center(
                                                    child: Text(
                                                      'No episodes match the current search/filter settings.',
                                                    ),
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
                                                    final isEpisodeFinished = isPodcastEpisodeFinished(
                                                      item: widget.item,
                                                      episode: episode,
                                                      progressByKey: progressMap,
                                                    );
                                                    final isQueued = queueSnapshot.entries.any(
                                                      (entry) =>
                                                          entry.item.itemId == widget.item.id &&
                                                          entry.item.episodeId == episode.id,
                                                    );

                                                    final isCurrentEpisode =
                                                        audioHandler.currentMediaItem?.itemId == widget.item.id &&
                                                        audioHandler.currentMediaItem?.episodeId == episode.id;
                                                    final isPlayingCurrentEpisode =
                                                        isCurrentEpisode && (playerState?.playing ?? false);
                                                    final episodeDownload = _episodeDownloadFor(
                                                      storedDownloads,
                                                      episode.id,
                                                    );
                                                    final isDownloaded = episodeDownload?.isComplete ?? false;
                                                    final isDownloading = activeTasks.any(
                                                      (task) => downloadHandler.taskBelongsToItem(
                                                        task,
                                                        widget.item.id,
                                                        episodeId: episode.id,
                                                      ),
                                                    );

                                                    return PodcastEpisodeTile(
                                                      episode: episode,
                                                      progress: episodeProgress,
                                                      canDownload: widget.canDownload,
                                                      isDownloading: isDownloading,
                                                      isDownloaded: isDownloaded,
                                                      isQueued: isQueued,
                                                      isCurrentEpisode: isCurrentEpisode,
                                                      isPlayingCurrentEpisode: isPlayingCurrentEpisode,
                                                      selectionMode: _selectionMode,
                                                      isSelected: _selectedEpisodeIds.contains(episode.id),
                                                      onSelectedChanged: (selected) {
                                                        setState(() {
                                                          if (selected == true) {
                                                            _selectedEpisodeIds.add(episode.id);
                                                            _selectionMode = true;
                                                          } else {
                                                            _selectedEpisodeIds.remove(episode.id);
                                                            if (_selectedEpisodeIds.isEmpty) {
                                                              _selectionMode = false;
                                                            }
                                                          }
                                                        });
                                                      },
                                                      onOpenDetails: () =>
                                                          _openEpisodeDetails(episode, visibleEpisodes),
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
                                                      onDownloadPressed: widget.canDownload && !isDownloaded
                                                          ? () => _queueEpisodeDownload(episode)
                                                          : null,
                                                      onDeletePressed:
                                                          isDownloaded && currentUser != null && episodeDownload != null
                                                          ? () => _deleteEpisodeDownload(
                                                              download: episodeDownload,
                                                              userId: currentUser.id,
                                                            )
                                                          : null,
                                                      showMarkAsUnfinished: isEpisodeFinished,
                                                      onMoreActionSelected: (action) async {
                                                        switch (action) {
                                                          case ItemMoreAction.editItem:
                                                          case ItemMoreAction.quickMatch:
                                                          case ItemMoreAction.manualMatch:
                                                            return;
                                                          case ItemMoreAction.markAsFinished:
                                                            await markPodcastEpisodeAsFinished(
                                                              context: context,
                                                              ref: ref,
                                                              item: widget.item,
                                                              episode: episode,
                                                            );
                                                            return;
                                                          case ItemMoreAction.markAsUnfinished:
                                                            await markPodcastEpisodeAsUnfinished(
                                                              context: context,
                                                              ref: ref,
                                                              item: widget.item,
                                                              episode: episode,
                                                            );
                                                            return;
                                                          case ItemMoreAction.addToPlaylist:
                                                          case ItemMoreAction.addToCollection:
                                                          case ItemMoreAction.deleteItem:
                                                            return;
                                                          case ItemMoreAction.playHistory:
                                                            if (!context.mounted) {
                                                              return;
                                                            }
                                                            context.push(
                                                              PlayHistoryView.location(
                                                                itemId: widget.item.id,
                                                                episodeId: episode.id,
                                                                itemTitle: podcastEpisodeTitle(episode),
                                                              ),
                                                            );
                                                            return;
                                                          case ItemMoreAction.select:
                                                            setState(() {
                                                              _selectionMode = true;
                                                              _selectedEpisodeIds.add(episode.id);
                                                            });
                                                            return;
                                                        }
                                                      },
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
              },
            );
          },
        );
      },
    );
  }

  Future<void> _findEpisodes() async {
    if (_isFetchingPodcastFeed) {
      return;
    }

    final feedUrl = widget.item.media?.podcastMedia?.metadata.feedUrl?.trim();
    if (feedUrl == null || feedUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('This podcast does not have an RSS feed URL.')));
      return;
    }

    setState(() {
      _isFetchingPodcastFeed = true;
    });

    PodcastFeed? feed;
    try {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw Exception('API not available');
      }

      final response = await api.getPodcastApi().getPodcastFeed(rssFeed: feedUrl);
      feed = response.data?.podcast;
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not load podcast feed: $e')));
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingPodcastFeed = false;
        });
      }
    }

    if (!mounted || feed == null) {
      return;
    }

    final feedEpisodes = feed.episodes
        .where((episode) => (episode.enclosure?.url ?? '').trim().isNotEmpty)
        .toList(growable: false);
    if (feedEpisodes.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No downloadable episodes were found in the RSS feed.')));
      return;
    }

    final selectedEpisodes = await showPodcastFindEpisodesDialog(
      context: context,
      podcastTitle: widget.item.title,
      episodes: feedEpisodes,
      existingEpisodes: widget.item.media?.podcastMedia?.episodes ?? const <Episode>[],
    );

    if (!mounted || selectedEpisodes == null || selectedEpisodes.isEmpty) {
      return;
    }

    await _downloadPodcastFeedEpisodes(selectedEpisodes);
  }

  Future<void> _downloadPodcastFeedEpisodes(List<PodcastFeedEpisode> episodes) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      return;
    }

    try {
      final started = await runWithLoadingSnackBar<bool>(
        context: context,
        message: 'Queuing episode downloads...',
        action: () => api.getPodcastApi().downloadPodcastEpisodes(libraryItemId: widget.item.id, episodes: episodes),
      );
      if (!mounted) {
        return;
      }

      if (started) {
        final count = episodes.length;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(count == 1 ? 'Started downloading 1 episode.' : 'Started downloading $count episodes.'),
          ),
        );
        ref.invalidate(libraryItemProvider(widget.item.id));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not queue podcast episodes for download.')));
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not queue podcast episodes: $e')));
    }
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

  Future<void> _queueEpisodeDownload(Episode episode) async {
    try {
      await downloadHandler.downloadFile(widget.item.id, episodeId: episode.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download added to queue.')));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not start download: $e')));
    }
  }

  InternalDownload? _episodeDownloadFor(List<InternalDownload> downloads, String episodeId) {
    for (final download in downloads) {
      if (download.episode?.id == episodeId) {
        return download;
      }
    }
    return null;
  }

  Future<void> _deleteEpisodeDownload({required InternalDownload download, required String userId}) async {
    try {
      final result = await runWithLoadingSnackBar(
        context: context,
        message: 'Deleting downloaded files...',
        action: () => downloadHandler.deleteDownloadedItem(download, userId: userId),
      );
      if (!mounted) {
        return;
      }
      final failedSuffix = result.failedFiles > 0 ? ' ${result.failedFiles} file(s) could not be removed.' : '';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deleted ${result.deletedFiles} file(s).$failedSuffix')));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not delete download: $e')));
    }
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
        return !podcastEpisodeCompleted(progress);
      case PodcastEpisodeProgressFilter.inProgress:
        return podcastEpisodeInProgress(progress);
      case PodcastEpisodeProgressFilter.complete:
        return podcastEpisodeCompleted(progress);
    }
  }

  PodcastEpisodeProgressFilter _progressFilterFromSettingValue(String value) {
    for (final candidate in PodcastEpisodeProgressFilter.values) {
      if (candidate.name == value) {
        return candidate;
      }
    }
    return PodcastEpisodeProgressFilter.all;
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

  void _showDownloadOptionsDialog({
    required List<Episode> notStartedEpisodes,
    required List<Episode> unfinishedEpisodes,
    required List<TaskRecord> activePodcastTasks,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Download Episodes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.play_circle_outline_rounded),
                title: const Text('Download not started episodes'),
                subtitle: Text('${notStartedEpisodes.length} episodes'),
                enabled: notStartedEpisodes.isNotEmpty,
                onTap: () {
                  Navigator.pop(dialogContext);
                  _downloadEpisodesList(notStartedEpisodes);
                },
              ),
              ListTile(
                leading: const Icon(Icons.hourglass_empty_rounded),
                title: const Text('Download unfinished episodes'),
                subtitle: Text('${unfinishedEpisodes.length} episodes'),
                enabled: unfinishedEpisodes.isNotEmpty,
                onTap: () {
                  Navigator.pop(dialogContext);
                  _downloadEpisodesList(unfinishedEpisodes);
                },
              ),
              if (activePodcastTasks.isNotEmpty) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.cancel_outlined, color: Colors.red),
                  title: const Text('Cancel active downloads', style: TextStyle(color: Colors.red)),
                  subtitle: Text('${activePodcastTasks.length} downloads active'),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    _cancelActiveDownloads(activePodcastTasks);
                  },
                ),
              ],
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel'))],
        );
      },
    );
  }

  Future<void> _downloadEpisodesList(List<Episode> episodes) async {
    if (episodes.isEmpty) return;
    var count = 0;
    for (final episode in episodes) {
      try {
        await downloadHandler.downloadFile(widget.item.id, episodeId: episode.id);
        count++;
      } catch (e) {
        logger('Could not download episode ${episode.title}: $e', tag: 'PodcastView', level: InfoLevel.error);
      }
    }
    if (mounted) {
      final message = count == 1 ? '1 download added to queue.' : '$count downloads added to queue.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _cancelActiveDownloads(List<TaskRecord> tasks) async {
    var count = 0;
    for (final task in tasks) {
      final canceled = await downloadHandler.cancelTask(task.taskId);
      if (canceled) {
        count++;
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cancelled $count ongoing download(s).')));
    }
  }

  Future<void> _downloadSelectedEpisodes(
    List<Episode> visibleEpisodes,
    List<InternalDownload> storedDownloads,
    List<TaskRecord> activeTasks,
  ) async {
    final episodesToDownload = visibleEpisodes.where((e) {
      if (!_selectedEpisodeIds.contains(e.id)) return false;
      final isDownloaded = storedDownloads.any((d) => d.episode?.id == e.id && d.isComplete);
      final isDownloading = activeTasks.any(
        (task) => downloadHandler.taskBelongsToItem(task, widget.item.id, episodeId: e.id),
      );
      return !isDownloaded && !isDownloading;
    }).toList();

    if (episodesToDownload.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No new episodes to download in selection.')));
      }
      setState(() {
        _selectionMode = false;
        _selectedEpisodeIds.clear();
      });
      return;
    }

    setState(() {
      _selectionMode = false;
      _selectedEpisodeIds.clear();
    });

    await _downloadEpisodesList(episodesToDownload);
  }
}
