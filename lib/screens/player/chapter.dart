import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/screens/player/player_empty_state_mode.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';

class ChapterView extends StatefulWidget {
  const ChapterView({super.key, this.maxHeight, this.emptyMode = PlayerCollectionEmptyMode.full});

  final double? maxHeight;
  final PlayerCollectionEmptyMode emptyMode;

  @override
  State<ChapterView> createState() => _ChapterViewState();
}

class _ChapterViewState extends State<ChapterView> {
  final ScrollController _scrollController = ScrollController();
  static const double _chapterTileExtent = 64.0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InternalMedia?>(
      stream: audioHandler.mediaItemStream,
      builder: (context, asyncSnapshot) {
        final mediaItem = asyncSnapshot.data;
        if (mediaItem == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final chapters = mediaItem.chapters;
        if (chapters == null || chapters.isEmpty) {
          if (widget.emptyMode == PlayerCollectionEmptyMode.hide) {
            return const SizedBox.shrink();
          }

          final empty = widget.emptyMode == PlayerCollectionEmptyMode.compact
              ? const _ChapterCompactEmptyState()
              : _ChapterEmptyState(title: mediaItem.title);

          if (widget.maxHeight != null) {
            return SizedBox(height: widget.maxHeight, child: empty);
          }
          return empty;
        }

        return StreamBuilder<InternalChapter?>(
          stream: audioHandler.chapterStream,
          builder: (context, currentChapterSnapshot) {
            final currentChapter = currentChapterSnapshot.data;
            final currentIndex = currentChapter == null
                ? -1
                : chapters.indexWhere((chapter) => chapter == currentChapter);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (currentIndex >= 0 && _scrollController.hasClients) {
                final targetOffset = (currentIndex * _chapterTileExtent - 8).clamp(
                  0.0,
                  _scrollController.position.maxScrollExtent,
                );
                _scrollController.animateTo(
                  targetOffset,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });

            final list = ListView.builder(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
              itemExtent: _chapterTileExtent,
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                return ListTile(
                  title: Text(chapter.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    '${chapter.start.toDuration.toHhMmString()} - ${chapter.end.toDuration.toHhMmString()}',
                  ),
                  selected: chapter == currentChapter,
                  selectedTileColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                  onTap: () {
                    audioHandler.seekAbsolute(chapter.start.toDuration);
                  },
                );
              },
            );

            if (widget.maxHeight != null) {
              return SizedBox(height: widget.maxHeight, child: list);
            }

            return list;
          },
        );
      },
    );
  }
}

class _ChapterCompactEmptyState extends StatelessWidget {
  const _ChapterCompactEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            'No chapters available',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ChapterEmptyState extends StatelessWidget {
  const _ChapterEmptyState({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 36, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 10),
            Text('No chapters available', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
