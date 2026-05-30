import 'package:flutter/material.dart';
import 'package:yaabsa/api/podcast/library_podcast_title.dart';
import 'package:yaabsa/api/podcast/podcast_search_result.dart';
import 'package:yaabsa/components/app/library/cue_badge.dart';
import 'package:yaabsa/components/app/library/explicit_badge.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';

class PodcastAddResultEntry {
  const PodcastAddResultEntry({required this.id, required this.result, required this.existing});

  final String id;
  final PodcastSearchResult result;
  final LibraryPodcastTitle? existing;

  bool get isAlreadyInLibrary => existing != null;

  bool get hasFeed => result.feedUrl?.trim().isNotEmpty == true;

  String get title {
    final trimmed = result.title?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return 'Untitled podcast';
    }
    return trimmed;
  }

  String? get author {
    final trimmed = result.artistName?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  String? get feedUrl {
    final trimmed = result.feedUrl?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  int? get trackCount => result.trackCount;
}

class PodcastAddResultsExpressiveTable extends StatelessWidget {
  const PodcastAddResultsExpressiveTable({
    super.key,
    required this.entries,
    required this.onSelect,
    this.enabled = true,
  });

  final List<PodcastAddResultEntry> entries;
  final Future<void> Function(PodcastAddResultEntry entry) onSelect;
  final bool enabled;

  bool _isEntryDisabled(PodcastAddResultEntry entry) {
    return !enabled || entry.isAlreadyInLibrary;
  }

  double _entryOpacity(PodcastAddResultEntry entry) {
    return _isEntryDisabled(entry) ? 0.62 : 1.0;
  }

  Widget _buildPodcastCell(BuildContext context, PodcastAddResultEntry entry) {
    final colorScheme = Theme.of(context).colorScheme;

    return Opacity(
      opacity: _entryOpacity(entry),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PodcastResultCover(url: entry.result.cover, size: 56),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        entry.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    if (entry.result.explicit == true) ...[const SizedBox(width: 6), const ExplicitBadge()],
                  ],
                ),
                if (entry.trackCount != null && entry.trackCount! > 0) ...[
                  const SizedBox(height: 6),
                  CueBadge(label: '${entry.trackCount} episode'),
                ],
                if (entry.author != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    entry.author!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedCell(BuildContext context, PodcastAddResultEntry entry) {
    final colorScheme = Theme.of(context).colorScheme;
    final feedUrl = entry.feedUrl;

    if (feedUrl == null) {
      return Opacity(
        opacity: _entryOpacity(entry),
        child: Text(
          'Missing RSS feed URL',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.error),
        ),
      );
    }

    return Opacity(
      opacity: _entryOpacity(entry),
      child: Text(feedUrl, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  Future<void> _handleRowTap(PodcastAddResultEntry entry) async {
    if (_isEntryDisabled(entry)) {
      return;
    }

    await onSelect(entry);
  }

  @override
  Widget build(BuildContext context) {
    return ExpressiveActionTable<PodcastAddResultEntry>(
      rows: entries,
      rowId: (entry) => entry.id,
      onRowTap: enabled ? _handleRowTap : null,
      padding: EdgeInsets.zero,
      columns: [
        ExpressiveTableColumn<PodcastAddResultEntry>(
          id: 'podcast',
          label: 'Podcast',
          width: 360,
          headerTooltip: 'Podcast title and metadata',
          tooltipBuilder: (entry) => entry.title,
          cellBuilder: _buildPodcastCell,
          mobileCellBuilder: _buildPodcastCell,
        ),
        ExpressiveTableColumn<PodcastAddResultEntry>(
          id: 'feed',
          label: 'Feed',
          width: 280,
          headerTooltip: 'RSS feed URL',
          tooltipBuilder: (entry) => entry.feedUrl ?? 'Missing RSS feed URL',
          cellBuilder: _buildFeedCell,
          mobileCellBuilder: _buildFeedCell,
        ),
      ],
      actions: [
        ExpressiveTableAction<PodcastAddResultEntry>(
          icon: Icons.add_rounded,
          tooltip: 'Add podcast',
          tone: ExpressiveTableActionTone.primary,
          iconBuilder: (entry) {
            if (entry.isAlreadyInLibrary) {
              return Icons.check_rounded;
            }
            if (!entry.hasFeed) {
              return Icons.warning_amber_rounded;
            }
            return Icons.add_rounded;
          },
          tooltipBuilder: (entry) {
            if (entry.isAlreadyInLibrary) {
              return 'Already in library';
            }
            if (!entry.hasFeed) {
              return 'No RSS feed URL available';
            }
            if (!enabled) {
              return 'Search in progress';
            }
            return 'Add podcast';
          },
          isEnabled: (entry) => enabled && !entry.isAlreadyInLibrary && entry.hasFeed,
          onPressed: _handleRowTap,
        ),
      ],
      emptyTitle: 'No podcast search results yet',
      emptySubtitle: 'Search by title/creator or paste a RSS feed URL to start.',
    );
  }
}

class _PodcastResultCover extends StatelessWidget {
  const _PodcastResultCover({required this.size, this.url});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final normalized = url?.trim();
    final coverUrl = normalized == null || normalized.isEmpty ? null : normalized;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: coverUrl == null
            ? _fallbackCover(context)
            : Image.network(coverUrl, fit: BoxFit.cover, errorBuilder: (_, _, _) => _fallbackCover(context)),
      ),
    );
  }

  Widget _fallbackCover(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      child: Icon(Icons.podcasts_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}
