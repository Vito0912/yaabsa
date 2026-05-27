import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/api/admin/admin_rss_feed.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/util/item_formatters.dart';

Future<void> showAdminRssFeedDetailsDialog({
  required BuildContext context,
  required AdminRssFeed feed,
  required String? feedUrl,
  required String? coverImageUrl,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return _AdminRssFeedDetailsDialog(feed: feed, feedUrl: feedUrl, coverImageUrl: coverImageUrl);
    },
  );
}

class _AdminRssFeedDetailsDialog extends StatefulWidget {
  const _AdminRssFeedDetailsDialog({required this.feed, required this.feedUrl, required this.coverImageUrl});

  final AdminRssFeed feed;
  final String? feedUrl;
  final String? coverImageUrl;

  @override
  State<_AdminRssFeedDetailsDialog> createState() => _AdminRssFeedDetailsDialogState();
}

class _AdminRssFeedDetailsDialogState extends State<_AdminRssFeedDetailsDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _feedUrlController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _ownerEmailController;

  @override
  void initState() {
    super.initState();

    final metadata = widget.feed.meta;
    _titleController = TextEditingController(text: widget.feed.resolvedTitle);
    _feedUrlController = TextEditingController(text: (widget.feedUrl ?? widget.feed.feedUrl ?? '').trim());
    _descriptionController = TextEditingController(text: (metadata?.description ?? '').trim());
    _ownerNameController = TextEditingController(text: (metadata?.ownerName ?? '').trim());
    _ownerEmailController = TextEditingController(text: (metadata?.ownerEmail ?? '').trim());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _feedUrlController.dispose();
    _descriptionController.dispose();
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    super.dispose();
  }

  String _entityLabel(String? entityType) {
    final normalized = (entityType ?? '').trim().toLowerCase();
    if (normalized == 'libraryitem') {
      return 'Item';
    }
    if (normalized == 'series') {
      return 'Series';
    }
    if (normalized == 'collection') {
      return 'Collection';
    }
    if (normalized.isEmpty) {
      return 'Unknown';
    }
    return normalized;
  }

  DateTime? _parseDateTime(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return DateTime.tryParse(trimmed);
  }

  String _episodeDuration(AdminRssFeedEpisode episode) {
    final durationSeconds = episode.duration;
    if (durationSeconds == null || durationSeconds <= 0) {
      return 'Unknown';
    }

    return formatDurationLong(Duration(seconds: durationSeconds.round()));
  }

  String? _episodeNumberLabel(AdminRssFeedEpisode episode) {
    final season = episode.season?.trim();
    final episodeNumber = episode.episode?.trim();
    if (season != null && season.isNotEmpty && episodeNumber != null && episodeNumber.isNotEmpty) {
      return 'S$season E$episodeNumber';
    }

    if (episodeNumber != null && episodeNumber.isNotEmpty) {
      return 'E$episodeNumber';
    }

    return null;
  }

  String _episodeTitle(AdminRssFeedEpisode episode) {
    final title = episode.title?.trim();
    if (title == null || title.isEmpty) {
      return 'Untitled episode';
    }

    return title;
  }

  List<AdminRssFeedEpisode> _sortedEpisodes() {
    final episodes = List<AdminRssFeedEpisode>.from(widget.feed.episodes);
    episodes.sort((left, right) {
      final leftDate = _parseDateTime(left.pubDate);
      final rightDate = _parseDateTime(right.pubDate);

      if (leftDate == null && rightDate == null) {
        final leftTitle = (left.title ?? '').toLowerCase();
        final rightTitle = (right.title ?? '').toLowerCase();
        return leftTitle.compareTo(rightTitle);
      }

      if (leftDate == null) {
        return 1;
      }

      if (rightDate == null) {
        return -1;
      }

      return rightDate.compareTo(leftDate);
    });
    return episodes;
  }

  Future<void> _copyFeedUrl() async {
    final value = _feedUrlController.text.trim();
    if (value.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(const SnackBar(content: Text('Feed URL copied.')));
  }

  Widget _buildCover() {
    final imageUrl = widget.coverImageUrl?.trim();
    if (imageUrl == null || imageUrl.isEmpty) {
      return const SizedBox(width: 64, height: 64, child: Icon(Icons.rss_feed_rounded));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(width: 64, height: 64, child: Icon(Icons.rss_feed_rounded));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.feed.meta;
    final episodes = _sortedEpisodes();
    final episodeCount = widget.feed.episodes.length;
    final hasDescription = _descriptionController.text.trim().isNotEmpty;
    final hasOwnerName = _ownerNameController.text.trim().isNotEmpty;
    final hasOwnerEmail = _ownerEmailController.text.trim().isNotEmpty;

    return AlertDialog(
      title: const Text('RSS Feed Details'),
      content: SizedBox(
        width: 760,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCover(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.feed.resolvedTitle, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          '${_entityLabel(widget.feed.entityType)} • $episodeCount episodes',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              StyledTextField(label: 'Title', controller: _titleController, readOnly: true),
              const SizedBox(height: 10),
              StyledTextField(
                label: 'Feed URL',
                controller: _feedUrlController,
                readOnly: true,
                suffixIcon: IconButton(
                  tooltip: 'Copy feed URL',
                  onPressed: _feedUrlController.text.trim().isEmpty ? null : _copyFeedUrl,
                  icon: const Icon(Icons.copy_rounded),
                ),
              ),
              if (hasDescription) ...[
                const SizedBox(height: 10),
                StyledTextField(label: 'Description', controller: _descriptionController, readOnly: true, maxLines: 3),
              ],
              if (hasOwnerName || hasOwnerEmail) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (hasOwnerName)
                      Expanded(
                        child: StyledTextField(label: 'Owner Name', controller: _ownerNameController, readOnly: true),
                      ),
                    if (hasOwnerName && hasOwnerEmail) const SizedBox(width: 10),
                    if (hasOwnerEmail)
                      Expanded(
                        child: StyledTextField(label: 'Owner Email', controller: _ownerEmailController, readOnly: true),
                      ),
                  ],
                ),
              ],
              if (metadata?.preventIndexing == true) ...[
                const SizedBox(height: 8),
                Text(
                  'This feed is marked to prevent indexing.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
              const SizedBox(height: 12),
              Text('Episodes', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                child: ExpressiveActionTable<AdminRssFeedEpisode>(
                  rows: episodes,
                  rowId: (episode) => episode.id,
                  columns: [
                    ExpressiveTableColumn<AdminRssFeedEpisode>(
                      id: 'episode',
                      label: 'Episode',
                      width: 320,
                      cellBuilder: (context, episode) {
                        final type = episode.episodeType?.trim();
                        final number = _episodeNumberLabel(episode);
                        final tags = <String>[
                          if (type != null && type.isNotEmpty) type,
                          if (number != null && number.isNotEmpty) number,
                        ];

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_episodeTitle(episode), maxLines: 1, overflow: TextOverflow.ellipsis),
                            if (tags.isNotEmpty)
                              Text(
                                tags.join(' • '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                          ],
                        );
                      },
                      tooltipBuilder: (episode) => _episodeTitle(episode),
                    ),
                    ExpressiveTableColumn<AdminRssFeedEpisode>(
                      id: 'duration',
                      label: 'Duration',
                      width: 110,
                      alignment: ExpressiveTableCellAlignment.center,
                      cellBuilder: (context, episode) => Text(_episodeDuration(episode)),
                    ),
                    ExpressiveTableColumn<AdminRssFeedEpisode>(
                      id: 'author',
                      label: 'Author',
                      width: 150,
                      showOnMobile: false,
                      cellBuilder: (context, episode) {
                        final author = episode.author?.trim();
                        final resolved = author == null || author.isEmpty ? 'Unknown' : author;
                        return Text(resolved, maxLines: 1, overflow: TextOverflow.ellipsis);
                      },
                    ),
                    ExpressiveTableColumn<AdminRssFeedEpisode>(
                      id: 'size',
                      label: 'Size',
                      width: 80,
                      alignment: ExpressiveTableCellAlignment.end,
                      showOnMobile: false,
                      cellBuilder: (context, episode) {
                        final size = episode.enclosure?.size;
                        final resolved = size == null || size <= 0 ? 'Unknown' : formatBytes(size);
                        return Text(resolved, maxLines: 1, overflow: TextOverflow.ellipsis);
                      },
                    ),
                  ],
                  emptyTitle: 'No episodes in this feed',
                  emptySubtitle: 'Episodes will appear here when available.',
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
    );
  }
}
