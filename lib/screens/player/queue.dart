import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/bg_audio_handler.dart';

class PlayerQueueView extends StatelessWidget {
  const PlayerQueueView({super.key, this.showEmptyIcon = true});

  final bool showEmptyIcon;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerQueueSnapshot>(
      stream: audioHandler.queueSnapshotStream,
      initialData: audioHandler.queueSnapshot,
      builder: (context, snapshot) {
        final queueSnapshot = snapshot.data ?? const PlayerQueueSnapshot();
        final entries = queueSnapshot.entries;

        if (entries.isEmpty) {
          return _QueueEmptyState(
            showIcon: showEmptyIcon,
            autoQueueRemaining: queueSnapshot.autoQueueRemaining,
            autoQueueActive: queueSnapshot.autoQueueActive,
            canLoadMore: queueSnapshot.canLoadMoreAutoQueue,
            isLoading: queueSnapshot.autoQueueLoading,
          );
        }

        return Column(
          children: [
            Expanded(
              child: ReorderableListView.builder(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: entries.length,
                onReorder: audioHandler.reorderQueue,
                buildDefaultDragHandles: false,
                itemBuilder: (context, index) {
                  final entry = entries[index];

                  return _QueueTile(entry: entry, index: index, key: ValueKey(entry.id));
                },
              ),
            ),
            if (queueSnapshot.autoQueueActive)
              _AutoQueueLoadMoreBar(
                remaining: queueSnapshot.autoQueueRemaining,
                canLoadMore: queueSnapshot.canLoadMoreAutoQueue,
                isLoading: queueSnapshot.autoQueueLoading,
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
                child: Icon(Icons.auto_awesome_rounded, size: 18, color: Theme.of(context).colorScheme.secondary),
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

class _AutoQueueLoadMoreBar extends StatelessWidget {
  const _AutoQueueLoadMoreBar({required this.remaining, required this.canLoadMore, required this.isLoading});

  final int remaining;
  final bool canLoadMore;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (remaining <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('and $remaining more to load', style: Theme.of(context).textTheme.bodySmall, maxLines: 2),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
            onPressed: canLoadMore
                ? () {
                    audioHandler.loadMoreAutoQueue();
                  }
                : null,
            child: isLoading
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Load more'),
          ),
        ],
      ),
    );
  }
}

class _QueueEmptyState extends StatelessWidget {
  const _QueueEmptyState({
    required this.showIcon,
    required this.autoQueueRemaining,
    required this.autoQueueActive,
    required this.canLoadMore,
    required this.isLoading,
  });

  final bool showIcon;
  final int autoQueueRemaining;
  final bool autoQueueActive;
  final bool canLoadMore;
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
            if (autoQueueActive && autoQueueRemaining > 0) ...[
              const SizedBox(height: 8),
              _AutoQueueLoadMoreBar(remaining: autoQueueRemaining, canLoadMore: canLoadMore, isLoading: isLoading),
            ],
          ],
        ),
      ),
    );
  }
}
