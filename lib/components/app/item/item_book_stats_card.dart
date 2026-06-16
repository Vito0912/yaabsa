import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/components/common/expressive_expandable_card.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/logger.dart';

class ItemBookStatsCard extends ConsumerStatefulWidget {
  const ItemBookStatsCard({
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
  ConsumerState<ItemBookStatsCard> createState() => _ItemBookStatsCardState();
}

class _ItemBookStatsCardState extends ConsumerState<ItemBookStatsCard> {
  bool _isLoading = false;
  bool _hasLoaded = false;
  String? _errorMessage;
  List<DateTime> _pastFinishDates = [];
  DateTime? _firstStarted;
  DateTime? _lastStarted;
  Duration _accumulatedListening = Duration.zero;

  Future<void> _loadStatsAndFinishes() async {
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

      final sortedSessions = allSessions.toList()
        ..sort((a, b) {
          final aTime = a.startedAt ?? a.updatedAt ?? 0;
          final bTime = b.startedAt ?? b.updatedAt ?? 0;
          return aTime.compareTo(bTime);
        });

      final double totalSeconds = sortedSessions.fold<double>(0.0, (sum, s) => sum + (s.timeListening ?? 0.0));

      final validTimeSessions = sortedSessions.where((s) => (s.startedAt ?? s.updatedAt ?? 0) > 0).toList();
      final firstSession = validTimeSessions.firstOrNull;
      final lastSession = validTimeSessions.lastOrNull;

      final firstStarted = firstSession != null
          ? DateTime.fromMillisecondsSinceEpoch(firstSession.startedAt ?? firstSession.updatedAt!)
          : null;
      final lastStarted = lastSession != null
          ? DateTime.fromMillisecondsSinceEpoch(lastSession.startedAt ?? lastSession.updatedAt!)
          : null;

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
          _firstStarted = firstStarted;
          _lastStarted = lastStarted;
          _accumulatedListening = Duration(seconds: totalSeconds.round());
          _hasLoaded = true;
          _isLoading = false;
        });
      }
    } catch (e, stack) {
      logger('Failed to load book stats: $e\n$stack', level: InfoLevel.error);
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

  Widget _buildStatCard({
    required BuildContext context,
    required String label,
    required String value,
    String? subtitle,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allFinishes = <DateTime>[];
    if (widget.isItemFinished && widget.itemProgress?.finishedAt != null) {
      allFinishes.add(DateTime.fromMillisecondsSinceEpoch(widget.itemProgress!.finishedAt!));
    }
    allFinishes.addAll(_pastFinishDates);

    return ExpressiveExpandableCard(
      margin: const EdgeInsets.only(top: 12),
      title: 'Book stats',
      initiallyExpanded: false,
      onExpansionChanged: (expanded) {
        if (expanded && !_hasLoaded && !_isLoading) {
          _loadStatsAndFinishes();
        }
      },
      childrenPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      childrenCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Theme.of(context).colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              ],
            ),
          )
        else if (_hasLoaded) ...[
          LayoutBuilder(
            builder: (context, constraints) {
              final parentWidth = constraints.maxWidth;
              final isWide = parentWidth > 600;
              final columns = isWide ? 4 : 2;
              const spacing = 12.0;
              final cardWidth = (parentWidth - (spacing * (columns - 1))) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: _buildStatCard(
                      context: context,
                      label: 'Total Listened',
                      value: formatDurationLong(_accumulatedListening),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _buildStatCard(
                      context: context,
                      label: 'Status',
                      value: widget.isItemFinished ? 'Finished' : '${(widget.progressValue * 100).toStringAsFixed(1)}%',
                      subtitle: widget.isItemFinished && widget.itemProgress?.finishedAt != null
                          ? _formatDate(DateTime.fromMillisecondsSinceEpoch(widget.itemProgress!.finishedAt!))
                          : 'In progress',
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _buildStatCard(
                      context: context,
                      label: 'First Started',
                      value: _firstStarted != null ? _formatDate(_firstStarted!) : 'N/A',
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _buildStatCard(
                      context: context,
                      label: 'Last Started',
                      value: _lastStarted != null ? _formatDate(_lastStarted!) : 'N/A',
                    ),
                  ),
                ],
              );
            },
          ),
          if (allFinishes.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Finish History',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ...allFinishes.asMap().entries.map((entry) {
              final index = entry.key;
              final date = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${allFinishes.length - index}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Finished',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _formatDate(date),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ] else ...[
          const SizedBox(height: 8),
          Text(
            widget.isItemFinished
                ? 'Finished'
                : 'Current progress: ${(widget.progressValue * 100).toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }
}
