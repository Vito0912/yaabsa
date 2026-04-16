import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/api/routes/abs_api.dart';

const int defaultMultiBookPreviewLimit = 5;
const int _maxRenderedSeriesCovers = 5;

class MultiBookEntryData {
  const MultiBookEntryData({
    required this.id,
    required this.title,
    required this.bookItemIds,
    this.subtitle,
    this.totalBooks,
  });

  final String id;
  final String title;
  final String? subtitle;
  final List<String> bookItemIds;
  final int? totalBooks;

  factory MultiBookEntryData.fromSeries(Series series) {
    final bookIds = _dedupeItemIds([...?series.books?.map((book) => book.id), ...?series.libraryItemIds]);

    return MultiBookEntryData(
      id: series.id,
      title: series.name,
      subtitle: series.numBooks != null ? '${series.numBooks} books' : null,
      bookItemIds: bookIds,
      totalBooks: series.numBooks ?? bookIds.length,
    );
  }

  factory MultiBookEntryData.fromPlaylist(Playlist playlist) {
    final itemCount = playlist.items?.length;
    final bookIds = _dedupeItemIds(
      playlist.items?.map((item) => item.libraryItem?.id ?? item.itemId) ?? const <String>[],
    );

    return MultiBookEntryData(
      id: playlist.id,
      title: playlist.name,
      subtitle: itemCount != null ? '$itemCount books' : null,
      bookItemIds: bookIds,
      totalBooks: itemCount ?? bookIds.length,
    );
  }

  factory MultiBookEntryData.fromCollection(Collection collection) {
    final itemCount = collection.items?.length;
    final bookIds = _dedupeItemIds(collection.items?.map((item) => item.id) ?? const <String>[]);

    return MultiBookEntryData(
      id: collection.id,
      title: collection.name,
      subtitle: itemCount != null ? '$itemCount books' : null,
      bookItemIds: bookIds,
      totalBooks: itemCount ?? bookIds.length,
    );
  }

  int get totalBookCount => totalBooks ?? bookItemIds.length;

  List<String> previewBookIds({int maxBooksToShow = defaultMultiBookPreviewLimit}) {
    final safeLimit = maxBooksToShow < 1 ? 1 : maxBooksToShow;
    return bookItemIds.where((id) => id.isNotEmpty).take(safeLimit).toList(growable: false);
  }
}

class MultiBookEntryWidget extends StatelessWidget {
  const MultiBookEntryWidget({
    required this.api,
    required this.entry,
    super.key,
    this.onTap,
    this.maxBooksToShow = defaultMultiBookPreviewLimit,
    this.compact = false,
    this.squareCover = true,
    this.showSubtitle = false,
    this.coverHeight,
  });

  final ABSApi api;
  final MultiBookEntryData entry;
  final VoidCallback? onTap;
  final int maxBooksToShow;
  final bool compact;
  final bool squareCover;
  final bool showSubtitle;
  final double? coverHeight;

  @override
  Widget build(BuildContext context) {
    final previewBookIds = entry.previewBookIds(maxBooksToShow: maxBooksToShow);
    final subtitle = _resolveSubtitle();
    final hiddenBookCount = (entry.totalBookCount - previewBookIds.length).clamp(0, entry.totalBookCount);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StackedCovers(
          api: api,
          itemIds: previewBookIds,
          hiddenBookCount: hiddenBookCount,
          compact: compact,
          squareCover: squareCover,
          coverHeight: coverHeight,
        ),
        SizedBox(height: compact ? 6 : 8),
        Text(
          entry.title,
          maxLines: compact ? 1 : 2,
          overflow: TextOverflow.ellipsis,
          style: compact ? Theme.of(context).textTheme.bodyMedium : null,
        ),
        if (showSubtitle && subtitle != null)
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
      ],
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: content),
    );
  }

  String? _resolveSubtitle() {
    if (entry.subtitle != null && entry.subtitle!.isNotEmpty) return entry.subtitle;
    if (entry.totalBookCount > 0) return '${entry.totalBookCount} books';
    return null;
  }
}

class _StackedCovers extends StatelessWidget {
  const _StackedCovers({
    required this.api,
    required this.itemIds,
    required this.hiddenBookCount,
    required this.compact,
    required this.squareCover,
    required this.coverHeight,
  });

  final ABSApi api;
  final List<String> itemIds;
  final int hiddenBookCount;
  final bool compact;
  final bool squareCover;
  final double? coverHeight;

  @override
  Widget build(BuildContext context) {
    if (coverHeight != null) {
      return SizedBox(height: coverHeight!, child: _buildCoverStack(context));
    }

    if (squareCover) {
      return AspectRatio(aspectRatio: 1, child: _buildCoverStack(context));
    }

    return SizedBox(height: compact ? 120 : 148, child: _buildCoverStack(context));
  }

  Widget _buildCoverStack(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final visibleIds = itemIds.take(_maxRenderedSeriesCovers).toList(growable: false);

    if (visibleIds.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.menu_book_outlined, color: colorScheme.onSurfaceVariant, size: compact ? 34 : 42),
        ),
      );
    }

    if (visibleIds.length == 1) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: _SingleCoverWithBlur(api: api, itemId: visibleIds.first, compact: compact),
          ),
          if (hiddenBookCount > 0)
            Positioned(top: -2, right: -4, child: _ExtraCountBadge(hiddenBookCount: hiddenBookCount)),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final count = visibleIds.length;
        final coverSize = math.min(width, height);
        final top = (height - coverSize) / 2;
        final defaultStep = coverSize * (compact ? 0.1 : 0.12);
        final availableStep = count <= 1 ? 0.0 : (width - coverSize) / (count - 1);
        final step = availableStep > 0 ? availableStep : defaultStep;
        final startLeft = availableStep > 0 ? 0.0 : -(step * (count - 1)) / 2;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    for (var i = 0; i < count; i++)
                      Positioned(
                        left: startLeft + i * step,
                        top: top,
                        width: coverSize,
                        height: coverSize,
                        child: _CoverCard(
                          child: api.getLibraryItemApi().getLibraryItemCover(
                            visibleIds[i],
                            width: coverSize,
                            height: coverSize,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (hiddenBookCount > 0)
              Positioned(top: -2, right: -4, child: _ExtraCountBadge(hiddenBookCount: hiddenBookCount)),
          ],
        );
      },
    );
  }
}

class _SingleCoverWithBlur extends StatelessWidget {
  const _SingleCoverWithBlur({required this.api, required this.itemId, required this.compact});

  final ABSApi api;
  final String itemId;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final foregroundSize = math.min(width, height);

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: compact ? 10 : 14, sigmaY: compact ? 10 : 14),
                child: api.getLibraryItemApi().getLibraryItemCover(itemId, width: width, height: height),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0, 0.2, 0.8, 1],
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: foregroundSize,
                  height: foregroundSize,
                  child: _CoverCard(
                    child: api.getLibraryItemApi().getLibraryItemCover(
                      itemId,
                      width: foregroundSize,
                      height: foregroundSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CoverCard extends StatelessWidget {
  const _CoverCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.surface, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.14), blurRadius: 7, offset: const Offset(0, 2))],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(14), child: child),
    );
  }
}

class _ExtraCountBadge extends StatelessWidget {
  const _ExtraCountBadge({required this.hiddenBookCount});

  final int hiddenBookCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.72), borderRadius: BorderRadius.circular(99)),
      child: Text('+$hiddenBookCount', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white)),
    );
  }
}

List<String> _dedupeItemIds(Iterable<String?> ids) {
  final seen = <String>{};
  final uniqueIds = <String>[];

  for (final id in ids) {
    if (id == null || id.isEmpty) continue;
    if (seen.add(id)) {
      uniqueIds.add(id);
    }
  }

  return uniqueIds;
}
