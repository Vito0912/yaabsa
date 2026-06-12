import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/components/common/expressive_expandable_card.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';

class ItemPastFinishesCard extends ConsumerStatefulWidget {
  const ItemPastFinishesCard({
    super.key,
    required this.item,
    required this.isItemFinished,
    required this.progressValue,
    this.itemProgress,
  });

  final LibraryItem item;
  final bool isItemFinished;
  final double progressValue;
  final MediaProgress? itemProgress;

  @override
  ConsumerState<ItemPastFinishesCard> createState() => _ItemPastFinishesCardState();
}

class _ItemPastFinishesCardState extends ConsumerState<ItemPastFinishesCard> {
  bool _isLoading = false;
  bool _hasLoaded = false;
  String? _errorMessage;
  List<DateTime> _pastFinishDates = [];

  Future<void> _loadPriorFinishes() async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      if (mounted) setState(() => _errorMessage = 'API not available');
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final libraryId = widget.item.libraryId;
      if (libraryId == null) {
        throw Exception('Library ID is null');
      }

      final libraryDetailsResponse = await api.getLibraryApi().getLibraryDetails(libraryId);
      final library = libraryDetailsResponse.data?.library;
      final markAsFinishedPercentComplete = library?.settings.markAsFinishedPercentComplete ?? 1.0;
      final markAsFinishedTimeRemaining = library?.settings.markAsFinishedTimeRemaining ?? 0;

      final allSessions = <PlaybackSession>[];
      int page = 0;
      int numPages = 1;
      const itemsPerPage = 100;

      while (page < numPages && allSessions.length < 500) {
        final response = await api.getMeApi().getMeItemListeningSessions(
          widget.item.id,
          page: page,
          itemsPerPage: itemsPerPage,
        );

        final pageData = response.data;
        if (pageData == null) {
          break;
        }

        allSessions.addAll(pageData.sessions);
        numPages = pageData.numPages ?? 1;
        page++;
      }

      final sortedSessions = allSessions.toList()..sort((a, b) => (a.updatedAt ?? 0).compareTo(b.updatedAt ?? 0));

      final finishes = <DateTime>[];
      bool wasFinished = false;

      for (final session in sortedSessions) {
        final duration = session.duration ?? widget.item.media?.duration() ?? 0;
        final currentTime = session.currentTime ?? 0;

        if (duration <= 0) continue;

        final isSessionFinished =
            (duration - currentTime <= markAsFinishedTimeRemaining) ||
            ((currentTime / duration) >= markAsFinishedPercentComplete);

        if (isSessionFinished && !wasFinished) {
          final updatedAt = session.updatedAt ?? session.startedAt;
          if (updatedAt != null) {
            finishes.add(DateTime.fromMillisecondsSinceEpoch(updatedAt));
          }
        }

        wasFinished = isSessionFinished;
      }

      // If the book is currently finished, remove the most recent finish if it matches the current finishedAt
      if (widget.isItemFinished && finishes.isNotEmpty && widget.itemProgress?.finishedAt != null) {
        final currentFinishedDate = DateTime.fromMillisecondsSinceEpoch(widget.itemProgress!.finishedAt!);
        // If the last finish is within a day of the current finishedAt, it's likely the same finish
        if (finishes.last.difference(currentFinishedDate).abs().inDays < 1) {
          finishes.removeLast();
        }
      }

      if (mounted) {
        setState(() {
          _pastFinishDates = finishes.reversed.toList();
          _hasLoaded = true;
          _isLoading = false;
        });
      }
    } catch (e, stack) {
      logger('Failed to load past finishes: $e\n$stack', level: InfoLevel.error);
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load: $e';
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ExpressiveExpandableCard(
      margin: const EdgeInsets.only(top: 12),
      title: 'Finish history',
      initiallyExpanded: false,
      onExpansionChanged: (expanded) {
        if (expanded && !_hasLoaded && !_isLoading) {
          _loadPriorFinishes();
        }
      },
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      childrenCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          widget.isItemFinished
              ? 'Finished on ${_formatDate(DateTime.fromMillisecondsSinceEpoch(widget.itemProgress?.finishedAt ?? DateTime.now().millisecondsSinceEpoch))}'
              : 'Current progress: ${(widget.progressValue * 100).toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 24, bottom: 8),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Theme.of(context).colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              ],
            ),
          ),
        if (_hasLoaded) ...[
          if (_pastFinishDates.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'History',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            ..._pastFinishDates.asMap().entries.map((entry) {
              final index = entry.key;
              final date = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${_pastFinishDates.length - index}.',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(_formatDate(date), style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              );
            }),
          ],
        ],
      ],
    );
  }
}
