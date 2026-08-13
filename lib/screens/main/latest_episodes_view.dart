import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/library_item_overlay_play_button.dart';
import 'package:yaabsa/components/common/loading_view.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/library/latest_episodes_provider.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/item_formatters.dart';

class LatestEpisodesView extends HookConsumerWidget {
  const LatestEpisodesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }
    if (selectedLibrary.mediaType != 'podcast') {
      return const Center(child: Text('Latest Episodes is available for podcast libraries.'));
    }

    final api = ref.watch(absApiProvider);
    if (api == null) {
      return ConnectionIssueView.offline(
        onRetry: () => ref.read(latestEpisodesProvider(selectedLibrary.id).notifier).refresh(),
      );
    }

    final provider = latestEpisodesProvider(selectedLibrary.id);
    final latestEpisodes = ref.watch(provider);
    final progressByKey = ref.watch(mediaProgressProvider).value ?? const <String, MediaProgress>{};
    final scrollController = useScrollController();
    final pendingEpisodeIds = useState(<String>{});
    final playbackState = useStream(audioHandler.playbackState);

    useEffect(() {
      void loadMoreWhenNeeded() {
        if (!scrollController.hasClients || scrollController.position.extentAfter > 480) {
          return;
        }
        unawaited(ref.read(provider.notifier).loadNextPage());
      }

      scrollController.addListener(loadMoreWhenNeeded);
      return () => scrollController.removeListener(loadMoreWhenNeeded);
    }, [scrollController, provider]);

    Future<void> playEpisode(Episode episode) async {
      final current = audioHandler.currentMediaItem;
      final isCurrent = current?.itemId == episode.libraryItemId && current?.episodeId == episode.id;
      if (isCurrent) {
        if (playbackState.data?.playing ?? false) {
          await audioHandler.pause();
        } else {
          await audioHandler.play();
        }
        return;
      }

      pendingEpisodeIds.value = {...pendingEpisodeIds.value, episode.id};
      try {
        final item = await ref.read(libraryItemProvider(episode.libraryItemId, episodeId: episode.id).future);
        final itemEpisodes = item.media?.podcastMedia?.episodes;
        Episode resolvedEpisode = episode;
        if (itemEpisodes != null) {
          for (final candidate in itemEpisodes) {
            if (candidate.id == episode.id) {
              resolvedEpisode = candidate;
              break;
            }
          }
        }
        audioHandler.playPodcastEpisode(item, resolvedEpisode);
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not play this episode: $error')));
        }
      } finally {
        pendingEpisodeIds.value = {...pendingEpisodeIds.value}..remove(episode.id);
      }
    }

    return latestEpisodes.when(
      skipLoadingOnRefresh: false,
      data: (state) {
        if (state.episodes.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => ref.read(provider.notifier).refresh(),
            child: ListView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 160),
                Icon(Icons.podcasts_rounded, size: 48),
                SizedBox(height: 16),
                Center(child: Text('No incomplete recent episodes found.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(provider.notifier).refresh(),
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(context.isMobile ? 12 : 24, 20, context.isMobile ? 12 : 24, 32),
            itemCount: state.episodes.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Latest Episodes', style: Theme.of(context).textTheme.headlineSmall),
                      ),
                    ),
                  ),
                );
              }

              if (index == state.episodes.length + 1) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: state.isLoadingNextPage
                      ? const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox(height: 8),
                );
              }

              final episode = state.episodes[index - 1];
              final current = audioHandler.currentMediaItem;
              final isCurrent = current?.itemId == episode.libraryItemId && current?.episodeId == episode.id;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _LatestEpisodeCard(
                      episode: episode,
                      progress: progressByKey[mediaProgressKey(episode.libraryItemId, episode.id)],
                      cover: api.getLibraryItemApi().getLibraryItemCover(
                        episode.libraryItemId,
                        width: context.isMobile ? 72 : 88,
                        height: context.isMobile ? 72 : 88,
                      ),
                      isCurrent: isCurrent,
                      isPlaying: isCurrent && (playbackState.data?.playing ?? false),
                      isLoading: pendingEpisodeIds.value.contains(episode.id),
                      onOpen: () => context.push('/item/${episode.libraryItemId}'),
                      onPlay: () => playEpisode(episode),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const LoadingView(showDownloadsShortcut: false),
      error: (error, stackTrace) => ConnectionIssueView.requestFailed(
        error: error,
        title: 'Could not load latest episodes',
        onRetry: () => ref.read(provider.notifier).refresh(),
        showDownloadsShortcut: false,
      ),
    );
  }
}

class _LatestEpisodeCard extends StatelessWidget {
  const _LatestEpisodeCard({
    required this.episode,
    required this.progress,
    required this.cover,
    required this.isCurrent,
    required this.isPlaying,
    required this.isLoading,
    required this.onOpen,
    required this.onPlay,
  });

  final Episode episode;
  final MediaProgress? progress;
  final Widget cover;
  final bool isCurrent;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onOpen;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final podcastTitle = episode.podcast?.metadata.title?.trim();
    final podcastAuthor = episode.podcast?.metadata.author?.trim();
    final publishedLabel = podcastFormatEpisodeDate(episode);
    final durationSeconds = episode.audioFile?.duration ?? episode.audioTrack?.duration ?? episode.duration;
    final durationLabel = durationSeconds == null
        ? null
        : formatDurationShort(Duration(seconds: durationSeconds.round()));
    final description = podcastEpisodeDescriptionPreview(episode);
    final progressValue = (progress?.progress ?? 0).clamp(0.0, 1.0).toDouble();
    final isFinished = progress?.isFinished ?? progressValue >= 0.999;
    final coverSize = context.isMobile ? 72.0 : 88.0;

    return Material(
      color: isCurrent ? colorScheme.primaryContainer.withValues(alpha: 0.24) : colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(width: coverSize, height: coverSize, child: cover),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      podcastEpisodeTitle(episode),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (podcastTitle != null && podcastTitle.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        podcastAuthor == null || podcastAuthor.isEmpty
                            ? podcastTitle
                            : '$podcastTitle · $podcastAuthor',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
                      ),
                    ],
                    if (description != null && !context.isMobile) ...[
                      const SizedBox(height: 5),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 10,
                      children: [
                        if (publishedLabel != null) Text(publishedLabel),
                        if (durationLabel != null) Text(durationLabel),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFinished ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                      border: Border.all(color: isCurrent ? colorScheme.primary : colorScheme.outlineVariant),
                    ),
                    child: Center(
                      child: LibraryItemOverlayPlayButton(
                        libraryItemId: episode.libraryItemId,
                        shelfEpisode: episode,
                        showProgressRing: progressValue > 0,
                        progressValue: progressValue,
                        isFinished: isFinished,
                        isCurrentItem: isCurrent,
                        isPlayingCurrentItem: isPlaying,
                        isEbook: false,
                        isLoading: isLoading,
                        onPlay: onPlay,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
