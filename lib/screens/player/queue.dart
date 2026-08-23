import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/player/player_empty_state_mode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';

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
            return const _QueueCompactEmptyState();
          }

          return _QueueEmptyState(showIcon: widget.showEmptyIcon, isLoading: queueSnapshot.autoQueueLoading);
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
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              ),
          ],
        );
      },
    );
  }
}

class _QueueCompactEmptyState extends StatelessWidget {
  const _QueueCompactEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.queue_music_rounded, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            'Queue is empty',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: ReorderableDragStartListener(
          index: index,
          child: Icon(Icons.drag_handle_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        title: titleFromQueue != null
            ? Text(titleFromQueue, maxLines: 1, overflow: TextOverflow.ellipsis)
            : FutureBuilder<LibraryItem?>(
                future: audioHandler.resolveQueueLibraryItem(entry.item.itemId),
                builder: (context, snapshot) {
                  final resolvedTitle = snapshot.data?.title;
                  if (resolvedTitle != null && resolvedTitle.isNotEmpty) {
                    return Text(resolvedTitle, maxLines: 1, overflow: TextOverflow.ellipsis);
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Loading title...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    );
                  }

                  return Text(entry.item.itemId, maxLines: 1, overflow: TextOverflow.ellipsis);
                },
              ),
        subtitle: subtitleFromQueue != null || authorFromQueue != null
            ? Text(
                subtitleFromQueue ?? authorFromQueue!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (entry.autoQueued)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(Icons.playlist_add_check_rounded, size: 18, color: Theme.of(context).colorScheme.secondary),
              ),
            IconButton(
              tooltip: 'Remove from queue',
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                audioHandler.removeQueueEntry(entry.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QueueEmptyState extends StatelessWidget {
  const _QueueEmptyState({required this.showIcon, required this.isLoading});

  final bool showIcon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon)
              Icon(Icons.queue_music_rounded, size: 36, color: Theme.of(context).colorScheme.onSurfaceVariant),
            if (showIcon) const SizedBox(height: 10),
            Text('Queue is empty', style: Theme.of(context).textTheme.titleMedium),
            if (isLoading) ...[
              const SizedBox(height: 8),
              const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            ],
          ],
        ),
      ),
    );
  }
}
