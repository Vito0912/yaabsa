import 'package:flutter/material.dart';
import 'package:yaabsa/api/podcast/podcast_search_result.dart';
import 'package:yaabsa/components/app/library/cue_badge.dart';
import 'package:yaabsa/components/app/library/explicit_badge.dart';

class PodcastAddResultTile extends StatelessWidget {
  const PodcastAddResultTile({super.key, required this.result, required this.isAlreadyInLibrary, required this.onTap});

  final PodcastSearchResult result;
  final bool isAlreadyInLibrary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final title = result.title?.trim().isNotEmpty == true ? result.title!.trim() : 'Untitled podcast';
    final author = result.artistName?.trim();
    final hasFeed = result.feedUrl?.trim().isNotEmpty == true;
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isCompact = viewportWidth < 420;
    final coverSize = isCompact ? 78.0 : 96.0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.62 : 1,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PodcastResultCover(url: result.cover, size: coverSize),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Row(
                              spacing: 8,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                if (result.explicit == true) const ExplicitBadge(),
                              ],
                            ),
                          ),
                          if (result.trackCount != null && result.trackCount! > 0)
                            CueBadge(label: '${result.trackCount} episode'),
                        ],
                      ),
                      if (author != null && author.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(author, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (isAlreadyInLibrary)
                            Chip(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              avatar: const Icon(Icons.check_circle_outline, size: 16),
                              label: const Text('Already in library'),
                              visualDensity: VisualDensity.compact,
                            ),
                          if (!hasFeed)
                            const Chip(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              avatar: Icon(Icons.warning_amber_rounded, size: 16),
                              label: Text('No RSS feed URL'),
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isCompact) ...[
                  const SizedBox(width: 8),
                  Icon(isAlreadyInLibrary ? Icons.check_rounded : Icons.add_rounded),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PodcastResultCover extends StatelessWidget {
  const _PodcastResultCover({this.url, required this.size});

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
