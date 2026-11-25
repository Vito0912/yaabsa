import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/api/admin/admin_rss_feed.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/ui/components/media/yaabsa_cover_image.dart';
import 'package:yaabsa/util/l10n.dart';

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
      return context.l10n.entityItem;
    }
    if (normalized == 'series') {
      return context.l10n.fieldSeries;
    }
    if (normalized == 'collection') {
      return context.l10n.fieldCollection;
    }
    if (normalized.isEmpty) {
      return context.l10n.statusUnknown;
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
      return context.l10n.statusUnknown;
    }

    return formatDurationLong(Duration(seconds: durationSeconds.round()), localizations: context.l10n);
  }

  String? _episodeNumberLabel(AdminRssFeedEpisode episode) {
    final season = episode.season?.trim();
    final episodeNumber = episode.episode?.trim();
    if (season != null && season.isNotEmpty && episodeNumber != null && episodeNumber.isNotEmpty) {
      return context.l10n.labelEpisodeSeasonAndNumber(season, episodeNumber);
    }

    if (episodeNumber != null && episodeNumber.isNotEmpty) {
      return context.l10n.labelEpisodeNumber(episodeNumber);
    }

    return null;
  }

  String _episodeTitle(AdminRssFeedEpisode episode) {
    final title = episode.title?.trim();
    if (title == null || title.isEmpty) {
      return context.l10n.untitledEpisode;
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
    messenger?.showSnackBar(SnackBar(content: Text(context.l10n.statusRssFeedUrlCopied)));
  }

  Widget _buildCover() {
    final imageUrl = widget.coverImageUrl?.trim();
    final coverUrl = imageUrl == null || imageUrl.isEmpty ? null : imageUrl;

    return YaabsaCoverImage(
      image: coverUrl == null ? null : NetworkImage(coverUrl),
      width: 64,
      height: 64,
      borderRadius: BorderRadius.circular(10),
      placeholder: const Icon(Icons.rss_feed_rounded),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final metadata = widget.feed.meta;
    final episodes = _sortedEpisodes();
    final episodeCount = widget.feed.episodes.length;
    final hasDescription = _descriptionController.text.trim().isNotEmpty;
    final hasOwnerName = _ownerNameController.text.trim().isNotEmpty;
    final hasOwnerEmail = _ownerEmailController.text.trim().isNotEmpty;

    return AlertDialog(
      title: Text(l10n.headingRssFeedDetails),
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
                          l10n.statusRssFeedEntitySummary(_entityLabel(widget.feed.entityType), episodeCount),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              StyledTextField(label: l10n.fieldTitle, controller: _titleController, readOnly: true),
              const SizedBox(height: 10),
              StyledTextField(
                label: l10n.fieldFeedUrl,
                controller: _feedUrlController,
                readOnly: true,
                suffixIcon: IconButton(
                  tooltip: l10n.actionCopyFeedUrl,
                  onPressed: _feedUrlController.text.trim().isEmpty ? null : _copyFeedUrl,
                  icon: const Icon(Icons.copy_rounded),
                ),
              ),
              if (hasDescription) ...[
                const SizedBox(height: 10),
                StyledTextField(
                  label: l10n.fieldDescription,
                  controller: _descriptionController,
                  readOnly: true,
                  maxLines: 3,
                ),
              ],
              if (hasOwnerName || hasOwnerEmail) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (hasOwnerName)
                      Expanded(
                        child: StyledTextField(
                          label: l10n.fieldOwnerName,
                          controller: _ownerNameController,
                          readOnly: true,
                        ),
                      ),
                    if (hasOwnerName && hasOwnerEmail) const SizedBox(width: 10),
                    if (hasOwnerEmail)
                      Expanded(
                        child: StyledTextField(
                          label: l10n.fieldOwnerEmail,
                          controller: _ownerEmailController,
                          readOnly: true,
                        ),
                      ),
                  ],
                ),
              ],
              if (metadata?.preventIndexing == true) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.messageRssFeedPreventIndexing,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                l10n.headingEpisodes,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ExpressiveActionTable<AdminRssFeedEpisode>(
                  rows: episodes,
                  rowId: (episode) => episode.id,
                  columns: [
                    ExpressiveTableColumn<AdminRssFeedEpisode>(
                      id: 'episode',
                      label: l10n.headingEpisode,
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
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                          ],
                        );
                      },
                      tooltipBuilder: (episode) => _episodeTitle(episode),
                    ),
                    ExpressiveTableColumn<AdminRssFeedEpisode>(
                      id: 'duration',
                      label: l10n.fieldDuration,
                      width: 110,
                      alignment: ExpressiveTableCellAlignment.center,
                      cellBuilder: (context, episode) => Text(_episodeDuration(episode)),
                    ),
                    ExpressiveTableColumn<AdminRssFeedEpisode>(
                      id: 'author',
                      label: l10n.fieldAuthor,
                      width: 150,
                      showOnMobile: false,
                      cellBuilder: (context, episode) {
                        final author = episode.author?.trim();
                        final resolved = author == null || author.isEmpty ? l10n.statusUnknown : author;
                        return Text(resolved, maxLines: 1, overflow: TextOverflow.ellipsis);
                      },
                    ),
                    ExpressiveTableColumn<AdminRssFeedEpisode>(
                      id: 'size',
                      label: l10n.fieldSize,
                      width: 80,
                      alignment: ExpressiveTableCellAlignment.end,
                      showOnMobile: false,
                      cellBuilder: (context, episode) {
                        final size = episode.enclosure?.size;
                        final resolved = size == null || size <= 0
                            ? l10n.statusUnknown
                            : formatBytes(size, localizations: l10n);
                        return Text(resolved, maxLines: 1, overflow: TextOverflow.ellipsis);
                      },
                    ),
                  ],
                  emptyTitle: l10n.statusNoEpisodesInRssFeed,
                  emptySubtitle: l10n.messageRssEpisodesAppearHere,
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.actionClose))],
    );
  }
}
