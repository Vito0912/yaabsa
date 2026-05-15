import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/common/loading_snackbar.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/bg_audio_handler.dart';
import 'package:yaabsa/util/item_formatters.dart';

class PodcastEpisodeDetailsPage extends StatelessWidget {
  const PodcastEpisodeDetailsPage({
    super.key,
    required this.item,
    required this.episode,
    required this.canDownload,
    required this.onPlayEpisode,
  });

  final LibraryItem item;
  final Episode episode;
  final bool canDownload;
  final VoidCallback onPlayEpisode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Episode')),
      body: SafeArea(
        child: PodcastEpisodeDetailsContent(
          item: item,
          episode: episode,
          canDownload: canDownload,
          onPlayEpisode: onPlayEpisode,
        ),
      ),
    );
  }
}

class PodcastEpisodeDetailsContent extends ConsumerWidget {
  const PodcastEpisodeDetailsContent({
    super.key,
    required this.item,
    required this.episode,
    required this.canDownload,
    required this.onPlayEpisode,
    this.showCloseButton = false,
  });

  final LibraryItem item;
  final Episode episode;
  final bool canDownload;
  final VoidCallback onPlayEpisode;
  final bool showCloseButton;

  InternalDownload? _episodeDownloadFor(List<InternalDownload> downloads) {
    for (final download in downloads) {
      if (download.episode?.id == episode.id) {
        return download;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(
      mediaProgressProvider.select((asyncValue) => asyncValue.value?[mediaProgressKey(item.id, episode.id)]),
    );

    final progressStatus = podcastEpisodeCompleted(progress)
        ? 'Complete'
        : podcastEpisodeInProgress(progress)
        ? 'In Progress'
        : 'Incomplete';

    final progressValue = (progress?.progress ?? 0).clamp(0.0, 1.0).toDouble();
    final publishedLabel = podcastFormatEpisodeDate(episode);
    final episodeDurationSeconds = episode.audioFile?.duration;
    final durationLabel = episodeDurationSeconds == null
        ? null
        : formatDurationShort(Duration(seconds: episodeDurationSeconds.round()));
    final fullDescription = podcastEpisodeDescriptionFullText(episode);

    final currentUser = ref.watch(currentUserProvider).value;
    final appDatabase = ref.watch(appDatabaseProvider);
    final storedDownloadsStream = currentUser == null
        ? Stream<List<InternalDownload>>.value(const <InternalDownload>[])
        : appDatabase.watchStoredDownloadsByUser(currentUser.id);
    final currentUserId = currentUser?.id;

    return StreamBuilder<List<TaskRecord>>(
      stream: downloadHandler.taskQueueStream,
      initialData: const <TaskRecord>[],
      builder: (context, taskSnapshot) {
        final activeTasks = taskSnapshot.data ?? const <TaskRecord>[];
        final isDownloading = activeTasks.any(
          (task) => downloadHandler.taskBelongsToItem(task, item.id, episodeId: episode.id),
        );

        return StreamBuilder<List<InternalDownload>>(
          stream: storedDownloadsStream,
          initialData: const <InternalDownload>[],
          builder: (context, storedSnapshot) {
            final downloads = storedSnapshot.data ?? const <InternalDownload>[];
            final episodeDownload = _episodeDownloadFor(downloads);
            final isDownloaded = episodeDownload?.isComplete ?? false;

            return StreamBuilder<PlayerQueueSnapshot>(
              stream: audioHandler.queueSnapshotStream,
              initialData: audioHandler.queueSnapshot,
              builder: (context, queueSnapshotBuilder) {
                final queueSnapshot = queueSnapshotBuilder.data ?? const PlayerQueueSnapshot();
                final isQueued = queueSnapshot.entries.any(
                  (entry) => entry.item.itemId == item.id && entry.item.episodeId == episode.id,
                );

                return StreamBuilder<PlayerState>(
                  stream: audioHandler.playerControlStateStream,
                  initialData: audioHandler.playerControlState,
                  builder: (context, playerStateBuilder) {
                    final playerState = playerStateBuilder.data;
                    final isCurrentEpisode =
                        audioHandler.currentMediaItem?.itemId == item.id &&
                        audioHandler.currentMediaItem?.episodeId == episode.id;
                    final isPlayingCurrentEpisode = isCurrentEpisode && (playerState?.playing ?? false);

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showCloseButton)
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.close_rounded),
                                tooltip: 'Close',
                              ),
                            ),
                          Text(podcastEpisodeTitle(episode), style: Theme.of(context).textTheme.titleLarge),
                          if (podcastEpisodeSubtitle(episode) != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                podcastEpisodeSubtitle(episode)!,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                            ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              if (publishedLabel != null) Text(publishedLabel),
                              if (durationLabel != null) Text(durationLabel),
                              Text(progressStatus),
                            ],
                          ),
                          if (progressValue > 0) ...[
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(value: progressValue, minHeight: 4),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              FilledButton.icon(
                                onPressed: () {
                                  if (isCurrentEpisode) {
                                    if (isPlayingCurrentEpisode) {
                                      audioHandler.pause();
                                    } else {
                                      audioHandler.play();
                                    }
                                    return;
                                  }

                                  onPlayEpisode();
                                },
                                icon: Icon(
                                  isCurrentEpisode && isPlayingCurrentEpisode
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                ),
                                label: Text(isCurrentEpisode && isPlayingCurrentEpisode ? 'Pause' : 'Play'),
                              ),
                              FilledButton.tonalIcon(
                                onPressed: isCurrentEpisode
                                    ? null
                                    : () {
                                        if (isQueued) {
                                          audioHandler.removeFromQueueByItemId(item.id, episodeId: episode.id);
                                        } else {
                                          audioHandler.addPodcastEpisodeToQueue(item, episode);
                                        }
                                      },
                                icon: Icon(isQueued ? Icons.playlist_remove_rounded : Icons.queue_music_rounded),
                                label: Text(isQueued ? 'Remove from Queue' : 'Add to Queue'),
                              ),
                              if (canDownload && isDownloading)
                                FilledButton.tonalIcon(
                                  onPressed: null,
                                  icon: const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2.2),
                                  ),
                                  label: const Text('Downloading'),
                                ),
                              if (canDownload && !isDownloading && isDownloaded)
                                FilledButton.tonalIcon(
                                  onPressed: currentUserId == null || episodeDownload == null
                                      ? null
                                      : () async {
                                          try {
                                            final result = await runWithLoadingSnackBar(
                                              context: context,
                                              message: 'Deleting downloaded files...',
                                              action: () => downloadHandler.deleteDownloadedItem(
                                                episodeDownload,
                                                userId: currentUserId,
                                              ),
                                            );
                                            if (!context.mounted) {
                                              return;
                                            }
                                            final failedSuffix = result.failedFiles > 0
                                                ? ' ${result.failedFiles} file(s) could not be removed.'
                                                : '';
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Deleted ${result.deletedFiles} file(s).$failedSuffix'),
                                              ),
                                            );
                                          } catch (e) {
                                            if (!context.mounted) {
                                              return;
                                            }
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(SnackBar(content: Text('Could not delete download: $e')));
                                          }
                                        },
                                  icon: const Icon(Icons.delete_outline_rounded),
                                  label: const Text('Delete download'),
                                ),
                              if (canDownload && !isDownloading && !isDownloaded)
                                FilledButton.tonalIcon(
                                  onPressed: () async {
                                    try {
                                      await downloadHandler.downloadFile(item.id, episodeId: episode.id);
                                      if (!context.mounted) {
                                        return;
                                      }
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(const SnackBar(content: Text('Download added to queue.')));
                                    } catch (e) {
                                      if (!context.mounted) {
                                        return;
                                      }
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(SnackBar(content: Text('Could not start download: $e')));
                                    }
                                  },
                                  icon: const Icon(Icons.download_rounded),
                                  label: const Text('Download'),
                                ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text('Description', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child: SelectableText(
                                fullDescription.isEmpty ? 'No description available.' : fullDescription,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
