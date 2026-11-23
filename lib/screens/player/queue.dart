import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/player/player_empty_state_mode.dart';
import 'package:yaabsa/features/player/widgets/player_collection_empty_presentation.dart';
import 'package:yaabsa/features/player/widgets/player_queue_item_presentation.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class PlayerQueueView extends StatefulWidget {
  const PlayerQueueView({super.key, this.showEmptyIcon = true, this.emptyMode = PlayerCollectionEmptyMode.full});

  final bool showEmptyIcon;
  final PlayerCollectionEmptyMode emptyMode;

  @override
  State<PlayerQueueView> createState() => _PlayerQueueViewState();
}

class _PlayerQueueViewState extends State<PlayerQueueView> {
  static const double _loadMoreThreshold = 320;

  final ScrollController _scrollController = ScrollController();
  bool _isReordering = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreIfNeeded);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadMoreIfNeeded)
      ..dispose();
    super.dispose();
  }

  void _loadMoreIfNeeded() {
    if (_isReordering || !_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    if (position.extentAfter > _loadMoreThreshold) {
      return;
    }

    final queueSnapshot = audioHandler.queueSnapshot;
    if (queueSnapshot.canLoadMoreAutoQueue) {
      audioHandler.loadMoreAutoQueue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerQueueSnapshot>(
      stream: audioHandler.queueSnapshotStream,
      initialData: audioHandler.queueSnapshot,
      builder: (context, snapshot) {
        final queueSnapshot = snapshot.data ?? const PlayerQueueSnapshot();
        final entries = queueSnapshot.entries;

        if (entries.isEmpty) {
          if (widget.emptyMode == PlayerCollectionEmptyMode.hide) {
            return const SizedBox.shrink();
          }

          if (widget.emptyMode == PlayerCollectionEmptyMode.compact) {
            return const PlayerCollectionEmptyPresentation(
              icon: Icons.queue_music_rounded,
              title: 'Queue is empty',
              density: PlayerCollectionEmptyDensity.compact,
            );
          }

          return PlayerCollectionEmptyPresentation(
            icon: Icons.queue_music_rounded,
            title: 'Queue is empty',
            showIcon: widget.showEmptyIcon,
            isLoading: queueSnapshot.autoQueueLoading,
          );
        }

        return Column(
          children: [
            Expanded(
              child: ReorderableListView.builder(
                scrollController: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: entries.length,
                onReorderItem: audioHandler.reorderQueue,
                onReorderStart: (_) {
                  _isReordering = true;
                },
                onReorderEnd: (_) {
                  _isReordering = false;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      _loadMoreIfNeeded();
                    }
                  });
                },
                buildDefaultDragHandles: false,
                itemBuilder: (context, index) {
                  final entry = entries[index];

                  return _QueueTile(entry: entry, index: index, key: ValueKey(entry.id));
                },
              ),
            ),
            if (queueSnapshot.autoQueueLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(width: 20, height: 20, child: YaabsaCircularProgressIndicator(strokeWidth: 2)),
              ),
          ],
        );
      },
    );
  }
}

class _QueueTile extends StatelessWidget {
  const _QueueTile({required this.entry, required this.index, required super.key});

  final PlayerQueueEntry entry;
  final int index;

  @override
  Widget build(BuildContext context) {
    final titleFromQueue = entry.displayInfo.title;
    final subtitleFromQueue = entry.displayInfo.subtitle;
    final authorFromQueue = entry.displayInfo.author;

    final subtitle = subtitleFromQueue ?? authorFromQueue;
    if (titleFromQueue != null && titleFromQueue.isNotEmpty) {
      return _buildQueueItem(context, titleFromQueue, subtitle);
    }

    return FutureBuilder<LibraryItem?>(
      future: audioHandler.resolveQueueLibraryItem(entry.item.itemId),
      builder: (context, snapshot) {
        final resolvedTitle = snapshot.data?.title;
        final String title;
        if (resolvedTitle != null && resolvedTitle.isNotEmpty) {
          title = resolvedTitle;
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          title = 'Loading title...';
        } else {
          title = entry.item.itemId;
        }

        return _buildQueueItem(context, title, subtitle);
      },
    );
  }

  Widget _buildQueueItem(BuildContext context, String title, String? subtitle) {
    return PlayerQueueItemPresentation(
      title: title,
      subtitle: subtitle,
      leading: ReorderableDragStartListener(
        index: index,
        child: Icon(Icons.drag_handle_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      autoQueued: entry.autoQueued,
      onRemove: () => audioHandler.removeQueueEntry(entry.id),
    );
  }
}
